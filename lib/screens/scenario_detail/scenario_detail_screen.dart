import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/scenario.dart';
import '../../providers/scenario_provider.dart';
import '../../providers/session_provider.dart';
import '../../core/constants/colors.dart';

class ScenarioDetailScreen extends ConsumerWidget {
  final String scenarioId;

  const ScenarioDetailScreen({
    super.key,
    required this.scenarioId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenarioAsync = ref.watch(scenarioByIdProvider(scenarioId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('시나리오 정보'),
      ),
      body: scenarioAsync.when(
        data: (scenario) {
          if (scenario == null) {
            return const Center(
              child: Text('시나리오를 찾을 수 없습니다'),
            );
          }

          return _buildContent(context, ref, scenario);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('오류: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Scenario scenario) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scenario.title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                _buildMetaInfo(context, scenario),
                const Divider(height: 32),
                Text(
                  '배경',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  scenario.background,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Text(
                  '학습 목표',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  scenario.learningGoals,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () {
                ref.read(currentSessionProvider.notifier).startSession(scenario.id);
                context.push('/chat');
              },
              child: const Text('훈련 시작'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaInfo(BuildContext context, Scenario scenario) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildInfoChip(
          context,
          icon: Icons.category,
          label: scenario.category,
        ),
        _buildInfoChip(
          context,
          icon: Icons.access_time,
          label: '${scenario.estimatedTime}분',
        ),
        _buildInfoChip(
          context,
          icon: Icons.signal_cellular_alt,
          label: _getDifficultyText(scenario.difficulty),
          color: _getDifficultyColor(scenario.difficulty),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: color ?? AppColors.primaryBlue,
      ),
      label: Text(label),
      backgroundColor: (color ?? AppColors.primaryBlue).withOpacity(0.1),
    );
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return '초급';
      case 'intermediate':
        return '중급';
      case 'advanced':
        return '고급';
      default:
        return difficulty;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }
}
