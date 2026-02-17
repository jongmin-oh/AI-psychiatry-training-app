import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/analytics_provider.dart';

class ImprovementLineChart extends StatelessWidget {
  final List<SessionScore> scoreHistory;

  const ImprovementLineChart({
    super.key,
    required this.scoreHistory,
  });

  static const _lineColors = [
    AppColors.primaryBlue,
    AppColors.success,
    AppColors.accent,
    AppColors.error,
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '점수 추이',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (scoreHistory.length < 2)
              _buildNotEnoughData(context)
            else ...[
              _buildLegend(context),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: LineChart(_buildChart()),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotEnoughData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          '2회 이상 훈련을 완료하면 추이 그래프가 표시됩니다.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.secondaryText,
              ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: List.generate(categoryKeys.length, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 3,
              color: _lineColors[i],
            ),
            const SizedBox(width: 4),
            Text(
              categoryLabels[categoryKeys[i]]!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }),
    );
  }

  LineChartData _buildChart() {
    final maxX = (scoreHistory.length - 1).toDouble();

    return LineChartData(
      minY: 0,
      maxY: 5.5,
      minX: 0,
      maxX: maxX,
      gridData: FlGridData(
        show: true,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.2),
          strokeWidth: 1,
        ),
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value % 1 != 0 || value < 0 || value > 5) {
                return const SizedBox.shrink();
              }
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx < 0 || idx >= scoreHistory.length) {
                return const SizedBox.shrink();
              }
              return Text(
                '${idx + 1}회',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.secondaryText,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: List.generate(categoryKeys.length, (catIdx) {
        final key = categoryKeys[catIdx];
        return LineChartBarData(
          spots: scoreHistory.map((s) {
            final score = s.scores[key]?.toDouble() ?? 0;
            return FlSpot(s.index.toDouble(), score);
          }).toList(),
          isCurved: true,
          curveSmoothness: 0.3,
          color: _lineColors[catIdx],
          barWidth: 2,
          dotData: FlDotData(
            show: scoreHistory.length <= 10,
          ),
          belowBarData: BarAreaData(show: false),
        );
      }),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final key = categoryKeys[spot.barIndex];
              return LineTooltipItem(
                '${categoryLabels[key]}: '
                '${spot.y.toStringAsFixed(0)}',
                TextStyle(
                  color: _lineColors[spot.barIndex],
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
