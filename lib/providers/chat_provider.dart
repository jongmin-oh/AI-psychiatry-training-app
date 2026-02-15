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

// AI Typing state Provider
final isAITypingProvider = StateProvider<bool>((ref) => false);

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

      // Show AI typing indicator
      ref.read(isAITypingProvider.notifier).state = true;

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

      // Add difficulty-based progression guidelines
      final progressionGuide = _getProgressionGuideline(
        scenario.difficulty,
        currentSession.messages.length,
      );
      systemPrompt += '\n\n$progressionGuide';

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

      // Hide AI typing indicator
      ref.read(isAITypingProvider.notifier).state = false;

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      // Hide AI typing indicator even on error
      ref.read(isAITypingProvider.notifier).state = false;
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

  String _getProgressionGuideline(String difficulty, int messageCount) {
    final turnNumber = (messageCount / 2).ceil();

    final baseGuideline = '''

=== 감정 상태 변화 가이드라인 ===
현재 ${turnNumber}번째 대화 턴입니다.

상담사의 마지막 메시지를 분석하세요:
- 진정한 공감과 경청을 보였는가?
- 판단하지 않고 이해하려 노력했는가?
- 적절한 질문으로 탐색을 도왔는가?
- 성급한 조언이나 해결책을 강요하지 않았는가?

''';

    switch (difficulty) {
      case 'beginner':
        if (turnNumber <= 2) {
          return baseGuideline +
              '''
아직 초반이므로 조심스럽게 반응하되, 상담사가 기본적인 공감을 보이면 조금씩 구체적으로 이야기하세요.
''';
        } else if (turnNumber <= 5) {
          return baseGuideline +
              '''
상담사가 지속적으로 공감해주었다면 이제는 더 편하게 마음을 열고 이야기할 수 있습니다.
감정을 조금 더 솔직하게 표현하세요.
''';
        } else {
          return baseGuideline +
              '''
충분히 대화가 진행되었습니다. 상담사가 좋은 상담을 했다면:
- 조금씩 긍정적인 측면도 보이기 시작하세요
- "조금 나아진 것 같아요" 같은 작은 변화를 표현할 수 있습니다
- 하지만 여전히 고민은 남아있음을 보이세요
단, 상담사가 성급한 조언만 했다면 여전히 방어적일 수 있습니다.
''';
        }

      case 'intermediate':
        if (turnNumber <= 4) {
          return baseGuideline +
              '''
아직은 신중한 태도를 유지하세요. 상담사가 진심으로 공감하는지 지켜보는 중입니다.
상담사가 판단하지 않고 경청한다면 조금씩 더 이야기할 수 있습니다.
''';
        } else if (turnNumber <= 7) {
          return baseGuideline +
              '''
상담사가 일관되게 좋은 공감과 경청을 보여주었다면 이제 조금 더 마음을 열 수 있습니다.
하지만 여전히 문제 해결은 어렵고, 확신은 없습니다.
상담사가 성급한 조언을 했다면 다시 방어적으로 변할 수 있습니다.
''';
        } else {
          return baseGuideline +
              '''
충분한 대화 끝에, 상담사가 훌륭한 공감과 비판단적 태도를 유지했다면:
- "생각해볼 수 있을 것 같아요" 같은 작은 가능성을 보일 수 있습니다
- 하지만 여전히 불안하고 확신은 없습니다
- 급격한 변화는 없지만, 희망의 실마리가 보이기 시작합니다
상담사가 미흡했다면 여전히 혼란스럽고 답답해합니다.
''';
        }

      case 'advanced':
        if (turnNumber <= 6) {
          return baseGuideline +
              '''
매우 신중하고 방어적인 태도를 유지하세요. 쉽게 마음을 열지 않습니다.
상담사가 탁월한 공감과 완전히 비판단적인 태도를 보여도 아직은 의심하고 조심스러워합니다.
성급한 조언이나 판단이 조금이라도 있으면 즉시 닫힙니다.
''';
        } else if (turnNumber <= 10) {
          return baseGuideline +
              '''
상담사가 지속적으로 탁월한 공감과 경청을 보여주었다면 아주 조금씩 마음을 열기 시작합니다.
하지만 여전히 매우 조심스럽고, 쉽게 변하지 않습니다.
작은 방어적 반응은 계속 나올 수 있습니다.
''';
        } else {
          return baseGuideline +
              '''
오랜 시간 동안 상담사가 완벽에 가까운 공감과 비판단적 태도를 유지했다면:
- 아주 조금씩 "도움이 됐어요" 같은 표현을 할 수 있습니다
- 하지만 여전히 문제는 복잡하고 해결이 어렵습니다
- 극적인 변화는 없으며, 단지 "함께 고민해줘서 감사하다"는 정도입니다
상담사가 한 번이라도 실수했다면 여전히 닫혀있을 수 있습니다.
''';
        }

      default:
        return baseGuideline;
    }
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
