import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/training_session.dart';
import '../models/chat_message.dart';
import '../models/feedback.dart' as model;
import 'scenario_provider.dart';

// Current active session Provider
final currentSessionProvider = StateNotifierProvider<CurrentSessionNotifier, TrainingSession?>((ref) {
  return CurrentSessionNotifier(ref);
});

class CurrentSessionNotifier extends StateNotifier<TrainingSession?> {
  final Ref ref;

  CurrentSessionNotifier(this.ref) : super(null);

  void startSession(String scenarioId) {
    final uuid = const Uuid();
    state = TrainingSession(
      id: uuid.v4(),
      scenarioId: scenarioId,
      startTime: DateTime.now(),
      messages: [],
      isCompleted: false,
    );
  }

  void addMessage(ChatMessage message) {
    if (state == null) return;

    state = state!.copyWith(
      messages: [...state!.messages, message],
    );

    _saveSession();
  }

  void endSession(model.Feedback feedback) {
    if (state == null) return;

    state = state!.copyWith(
      endTime: DateTime.now(),
      isCompleted: true,
      feedback: feedback,
    );

    _saveSession();

    final storage = ref.read(storageServiceProvider);
    storage.markScenarioAsCompleted(state!.scenarioId);
  }

  void _saveSession() {
    if (state == null) return;

    final storage = ref.read(storageServiceProvider);
    storage.saveSession(state!);
  }

  void clearSession() {
    state = null;
  }
}

// All sessions Provider
final allSessionsProvider = Provider<List<TrainingSession>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getAllSessions();
});

// Completed sessions only Provider
final completedSessionsProvider = Provider<List<TrainingSession>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getCompletedSessions();
});
