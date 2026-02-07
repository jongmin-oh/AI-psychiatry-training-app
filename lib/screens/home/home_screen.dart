import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scenario_provider.dart';
import '../../widgets/scenario_card.dart';
import '../../core/constants/colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosAsync = ref.watch(scenariosProvider);
    final completedCount = ref.watch(completedScenarioCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 상담 트레이닝'),
      ),
      body: scenariosAsync.when(
        data: (scenarios) {
          final totalCount = scenarios.length;

          return Column(
            children: [
              _buildProgressSection(
                context,
                completedCount,
                totalCount,
              ),
              Expanded(
                child: scenarios.isEmpty
                    ? const Center(
                        child: Text('시나리오가 없습니다'),
                      )
                    : ListView.builder(
                        itemCount: scenarios.length,
                        itemBuilder: (context, index) {
                          final scenario = scenarios[index];
                          final isCompleted = ref.watch(
                            isScenarioCompletedProvider(scenario.id),
                          );

                          return ScenarioCard(
                            scenario: scenario,
                            isCompleted: isCompleted,
                            onTap: () {
                              context.push('/scenario/${scenario.id}');
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text('오류가 발생했습니다\n$error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Text(
                '나의 진행도',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '완료: $completed/$total 시나리오 (${(progress * 100).toStringAsFixed(0)}%)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
