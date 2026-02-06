import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/training_session.dart';
import '../../providers/session_provider.dart';
import '../../core/constants/colors.dart';

class FeedbackScreen extends ConsumerWidget {
  final TrainingSession session;

  const FeedbackScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedback = session.feedback;

    if (feedback == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('피드백'),
        ),
        body: const Center(
          child: Text('피드백이 없습니다'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('훈련 완료'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCongratulationsCard(context),
            const SizedBox(height: 24),
            Text(
              '평가 결과',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildScoresSection(context, feedback.scores),
            const SizedBox(height: 24),
            Text(
              '잘한 점',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            _buildFeedbackCard(
              context,
              feedback.goodPoints,
              AppColors.success,
            ),
            const SizedBox(height: 24),
            Text(
              '개선할 점',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            _buildFeedbackCard(
              context,
              feedback.improvements,
              AppColors.warning,
            ),
            const SizedBox(height: 32),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildCongratulationsCard(BuildContext context) {
    return Card(
      color: AppColors.primaryBlue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.celebration,
              size: 48,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '훈련 완료!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '수고하셨습니다',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoresSection(BuildContext context, Map<String, int> scores) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreRow(context, '공감 표현', scores['empathy'] ?? 0),
            const Divider(),
            _buildScoreRow(context, '경청 능력', scores['listening'] ?? 0),
            const Divider(),
            _buildScoreRow(context, '질문 적절성', scores['questioning'] ?? 0),
            const Divider(),
            _buildScoreRow(context, '해결책 제안', scores['solution'] ?? 0),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(BuildContext context, String label, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < score ? Icons.star : Icons.star_border,
                color: AppColors.warning,
                size: 24,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(BuildContext context, String content, Color accentColor) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: accentColor,
              width: 4,
            ),
          ),
        ),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(currentSessionProvider.notifier).clearSession();
            context.go('/');
          },
          child: const Text('메인으로'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            ref.read(currentSessionProvider.notifier).clearSession();
            context.go('/');
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('다시 시도'),
        ),
      ],
    );
  }
}
