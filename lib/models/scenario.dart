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
    required this.systemPrompt,
    required this.characterProfile,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);
  Map<String, dynamic> toJson() => _$ScenarioToJson(this);
}
