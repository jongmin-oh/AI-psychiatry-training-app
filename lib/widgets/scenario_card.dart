import 'package:flutter/material.dart';
import '../models/scenario.dart';
import '../core/constants/colors.dart';

class ScenarioCard extends StatelessWidget {
  final Scenario scenario;
  final bool isCompleted;
  final VoidCallback onTap;

  const ScenarioCard({
    super.key,
    required this.scenario,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      scenario.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  _buildDifficultyBadge(context),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                scenario.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${scenario.estimatedTime}분',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  if (isCompleted)
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '완료',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(BuildContext context) {
    Color color;
    String text;

    switch (scenario.difficulty) {
      case 'beginner':
        color = AppColors.success;
        text = '초급';
        break;
      case 'intermediate':
        color = AppColors.warning;
        text = '중급';
        break;
      case 'advanced':
        color = AppColors.error;
        text = '고급';
        break;
      default:
        color = AppColors.info;
        text = scenario.difficulty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
