import 'package:json_annotation/json_annotation.dart';
import 'chat_message.dart';
import 'feedback.dart';

part 'training_session.g.dart';

@JsonSerializable()
class TrainingSession {
  final String id;
  final String scenarioId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<ChatMessage> messages;
  final bool isCompleted;
  final Feedback? feedback;

  TrainingSession({
    required this.id,
    required this.scenarioId,
    required this.startTime,
    this.endTime,
    required this.messages,
    this.isCompleted = false,
    this.feedback,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) => _$TrainingSessionFromJson(json);
  Map<String, dynamic> toJson() => _$TrainingSessionToJson(this);

  TrainingSession copyWith({
    String? id,
    String? scenarioId,
    DateTime? startTime,
    DateTime? endTime,
    List<ChatMessage>? messages,
    bool? isCompleted,
    Feedback? feedback,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      scenarioId: scenarioId ?? this.scenarioId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      messages: messages ?? this.messages,
      isCompleted: isCompleted ?? this.isCompleted,
      feedback: feedback ?? this.feedback,
    );
  }
}
