import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'scenario.g.dart';

@JsonSerializable()
class Scenario {
  final String id;
  final String title;
  final String description;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final int estimatedTime; // minutes
  final String category;
  final String background;
  final String learningGoals;
  final List<String> greetings; // AI 학생의 첫인사 후보 (랜덤 선택)
  final List<Map<String, dynamic>> exampleDialogue; // 대화 예시
  final String systemPrompt;
  final Map<String, dynamic> characterProfile;

  Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedTime,
    required this.category,
    required this.background,
    required this.learningGoals,
    required this.greetings,
    this.exampleDialogue = const [],
    required this.systemPrompt,
    required this.characterProfile,
  });

  /// greetings 리스트에서 랜덤으로 하나 선택
  String getRandomGreeting() {
    if (greetings.isEmpty) return '';
    return greetings[Random().nextInt(greetings.length)];
  }

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioToJson(this);
}
