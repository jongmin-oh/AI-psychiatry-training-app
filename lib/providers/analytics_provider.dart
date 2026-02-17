import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_provider.dart';

const categoryLabels = {
  'empathy': '공감 표현',
  'listening': '경청 능력',
  'questioning': '질문 기술',
  'solution': '해결 방안',
};

const categoryKeys = ['empathy', 'listening', 'questioning', 'solution'];

class AnalyticsData {
  final int totalSessions;
  final double overallAverage;
  final Map<String, double> categoryAverages;
  final List<SessionScore> scoreHistory;
  final List<WeaknessItem> weaknesses;
  final double? improvementRate;

  const AnalyticsData({
    required this.totalSessions,
    required this.overallAverage,
    required this.categoryAverages,
    required this.scoreHistory,
    required this.weaknesses,
    this.improvementRate,
  });
}

class SessionScore {
  final int index;
  final DateTime date;
  final Map<String, int> scores;
  final double average;

  const SessionScore({
    required this.index,
    required this.date,
    required this.scores,
    required this.average,
  });
}

class WeaknessItem {
  final String key;
  final String label;
  final double average;
  final String recommendation;

  const WeaknessItem({
    required this.key,
    required this.label,
    required this.average,
    required this.recommendation,
  });
}

const _recommendations = {
  'empathy': '내담자의 감정을 반영하는 표현을 더 자주 사용해보세요.',
  'listening': '내담자의 말을 요약하고 확인하는 연습을 해보세요.',
  'questioning': '개방형 질문을 활용하여 내담자의 이야기를 이끌어보세요.',
  'solution': '내담자 스스로 해결책을 찾도록 안내하는 연습을 해보세요.',
};

final analyticsDataProvider = Provider<AnalyticsData?>((ref) {
  final sessions = ref.watch(completedSessionsProvider);

  final withFeedback = sessions
      .where((s) => s.feedback != null && s.feedback!.scores.isNotEmpty)
      .toList();

  if (withFeedback.isEmpty) return null;

  withFeedback.sort((a, b) => a.startTime.compareTo(b.startTime));

  final scoreHistory = <SessionScore>[];
  for (var i = 0; i < withFeedback.length; i++) {
    final f = withFeedback[i].feedback!;
    scoreHistory.add(SessionScore(
      index: i,
      date: withFeedback[i].startTime,
      scores: f.scores,
      average: f.averageScore,
    ));
  }

  final categoryAverages = <String, double>{};
  for (final key in categoryKeys) {
    final values = withFeedback
        .map((s) => s.feedback!.scores[key])
        .where((v) => v != null)
        .cast<int>()
        .toList();
    if (values.isNotEmpty) {
      categoryAverages[key] =
          values.reduce((a, b) => a + b) / values.length;
    }
  }

  final overallAverage = categoryAverages.values.isNotEmpty
      ? categoryAverages.values.reduce((a, b) => a + b) /
          categoryAverages.values.length
      : 0.0;

  double? improvementRate;
  if (withFeedback.length >= 2) {
    final mid = withFeedback.length ~/ 2;
    final firstHalf = withFeedback.sublist(0, mid);
    final secondHalf = withFeedback.sublist(mid);

    final firstAvg = firstHalf
            .map((s) => s.feedback!.averageScore)
            .reduce((a, b) => a + b) /
        firstHalf.length;
    final secondAvg = secondHalf
            .map((s) => s.feedback!.averageScore)
            .reduce((a, b) => a + b) /
        secondHalf.length;

    if (firstAvg > 0) {
      improvementRate = ((secondAvg - firstAvg) / firstAvg) * 100;
    }
  }

  final sortedCategories = categoryAverages.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));

  final weaknesses = sortedCategories
      .where((e) => e.value < 4.0)
      .map((e) => WeaknessItem(
            key: e.key,
            label: categoryLabels[e.key] ?? e.key,
            average: e.value,
            recommendation: _recommendations[e.key] ?? '',
          ))
      .toList();

  return AnalyticsData(
    totalSessions: withFeedback.length,
    overallAverage: overallAverage,
    categoryAverages: categoryAverages,
    scoreHistory: scoreHistory,
    weaknesses: weaknesses,
    improvementRate: improvementRate,
  );
});
