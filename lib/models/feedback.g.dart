// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feedback _$FeedbackFromJson(Map<String, dynamic> json) => Feedback(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      scores: Map<String, int>.from(json['scores'] as Map),
      goodPoints: json['goodPoints'] as String,
      improvements: json['improvements'] as String,
      recommendedScenarios: (json['recommendedScenarios'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FeedbackToJson(Feedback instance) => <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'scores': instance.scores,
      'goodPoints': instance.goodPoints,
      'improvements': instance.improvements,
      'recommendedScenarios': instance.recommendedScenarios,
      'createdAt': instance.createdAt.toIso8601String(),
    };
