import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  final String id;
  final String sessionId;
  final Map<String, int> scores; // {'empathy': 4, 'listening': 5, ...}
  final String goodPoints;
  final String improvements;
  final List<String> recommendedScenarios;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.sessionId,
    required this.scores,
    required this.goodPoints,
    required this.improvements,
    required this.recommendedScenarios,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);

  // Average score calculation
  double get averageScore {
    if (scores.isEmpty) return 0;
    int total = scores.values.reduce((a, b) => a + b);
    return total / scores.length;
  }
}
