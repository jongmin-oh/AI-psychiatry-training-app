import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/analytics_provider.dart';

class ScoreSummaryCard extends StatelessWidget {
  final AnalyticsData data;

  const ScoreSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '훈련 요약',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.school,
                    label: '총 훈련',
                    value: '${data.totalSessions}회',
                    color: AppColors.primaryBlue,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.star,
                    label: '평균 점수',
                    value: data.overallAverage.toStringAsFixed(1),
                    color: AppColors.accent,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.trending_up,
                    label: '개선율',
                    value: data.improvementRate != null
                        ? '${data.improvementRate! >= 0 ? '+' : ''}'
                            '${data.improvementRate!.toStringAsFixed(1)}%'
                        : '-',
                    color: data.improvementRate != null &&
                            data.improvementRate! >= 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
        ),
      ],
    );
  }
}
