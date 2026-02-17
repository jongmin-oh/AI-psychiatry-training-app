import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../providers/analytics_provider.dart';
import 'widgets/score_summary_card.dart';
import 'widgets/improvement_line_chart.dart';
import 'widgets/category_scores_chart.dart';
import 'widgets/weakness_report_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('분석 대시보드')),
      body: analytics == null
          ? _buildEmptyState(context)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ScoreSummaryCard(data: analytics),
                  const SizedBox(height: 12),
                  CategoryScoresChart(
                    categoryAverages: analytics.categoryAverages,
                  ),
                  const SizedBox(height: 12),
                  ImprovementLineChart(
                    scoreHistory: analytics.scoreHistory,
                  ),
                  const SizedBox(height: 12),
                  WeaknessReportCard(
                    weaknesses: analytics.weaknesses,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: AppColors.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '완료된 훈련이 없습니다',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '훈련을 완료하면 분석 결과를 확인할 수 있습니다.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.hintText,
                ),
          ),
        ],
      ),
    );
  }
}
