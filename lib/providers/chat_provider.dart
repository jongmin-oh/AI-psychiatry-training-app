import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/feedback.dart' as model;
import '../services/gemini_service.dart';
import 'session_provider.dart';
import 'scenario_provider.dart';

// GeminiService Provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

// Chat state Provider
final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<void>>((ref) {
  return ChatNotifier(ref);
});

class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  ChatNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;

    state = const AsyncValue.loading();

    try {
      final uuid = const Uuid();

      // 1. Add user message
      final userMessage = ChatMessage(
        id: uuid.v4(),
        sessionId: currentSession.id,
        sender: 'user',
        content: content.trim(),
        timestamp: DateTime.now(),
      );

      ref.read(currentSessionProvider.notifier).addMessage(userMessage);

      // 2. Generate AI response
      final scenario = await _getCurrentScenario();
      if (scenario == null) {
        throw Exception('시나리오를 찾을 수 없습니다');
      }

      final gemini = ref.read(geminiServiceProvider);

      final conversationHistory = currentSession.messages.map((msg) {
        return {
          'sender': msg.sender,
          'content': msg.content,
        };
      }).toList();

      var systemPrompt = scenario.systemPrompt;
      if (scenario.exampleDialogue.isNotEmpty) {
        final buffer = StringBuffer('\n\n대화 예시:\n');
        for (final turn in scenario.exampleDialogue) {
          final speaker = turn['sender'] == 'counselor' ? '상담원' : '학생';
          buffer.writeln('$speaker: ${turn['message']}');
        }
        buffer.write('\n위 예시를 참고하되, 똑같이 따라하지 말고 자연스럽게 대화하세요.');
        systemPrompt += buffer.toString();
      }

      final aiResponse = await gemini.generateAIResponse(
        systemPrompt: systemPrompt,
        conversationHistory: conversationHistory,
        userMessage: content,
      );

      // 3. Add AI message
      final aiMessage = ChatMessage(
        id: uuid.v4(),
        sessionId: currentSession.id,
        sender: 'ai',
        content: aiResponse,
        timestamp: DateTime.now(),
      );

      ref.read(currentSessionProvider.notifier).addMessage(aiMessage);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<dynamic> _getCurrentScenario() async {
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return null;

    final scenariosAsync = ref.read(scenariosProvider);
    return scenariosAsync.when(
      data: (scenarios) {
        try {
          return scenarios.firstWhere((s) => s.id == currentSession.scenarioId);
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  Future<model.Feedback?> generateFeedback() async {
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return null;

    state = const AsyncValue.loading();

    try {
      final gemini = ref.read(geminiServiceProvider);

      final conversationHistory = currentSession.messages.map((msg) {
        return {
          'sender': msg.sender,
          'content': msg.content,
        };
      }).toList();

      final feedbackData = await gemini.generateFeedback(
        conversationHistory: conversationHistory,
      );

      final uuid = const Uuid();
      final feedback = model.Feedback(
        id: uuid.v4(),
        sessionId: currentSession.id,
        scores: Map<String, int>.from(feedbackData['scores']),
        goodPoints: feedbackData['goodPoints'] as String,
        improvements: feedbackData['improvements'] as String,
        recommendedScenarios: List<String>.from(feedbackData['recommendedScenarios'] ?? []),
        createdAt: DateTime.now(),
      );

      state = const AsyncValue.data(null);
      return feedback;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}
