// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scenario _$ScenarioFromJson(Map<String, dynamic> json) => Scenario(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] as String,
      estimatedTime: (json['estimatedTime'] as num).toInt(),
      category: json['category'] as String,
      background: json['background'] as String,
      learningGoals: json['learningGoals'] as String,
      greetings: (json['greetings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      exampleDialogue: (json['exampleDialogue'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      systemPrompt: json['systemPrompt'] as String,
      characterProfile: json['characterProfile'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ScenarioToJson(Scenario instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'difficulty': instance.difficulty,
      'estimatedTime': instance.estimatedTime,
      'category': instance.category,
      'background': instance.background,
      'learningGoals': instance.learningGoals,
      'greetings': instance.greetings,
      'exampleDialogue': instance.exampleDialogue,
      'systemPrompt': instance.systemPrompt,
      'characterProfile': instance.characterProfile,
    };
