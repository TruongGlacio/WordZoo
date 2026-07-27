import 'package:flutter/material.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';

class ProgressBarWidget extends StatelessWidget {
  final int learned;
  final int total;

  const ProgressBarWidget({
    super.key,
    required this.learned,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? learned / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiến độ: $learned/$total từ', style: AppTextStyles.body),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.leafGreen),
        ),
      ],
    );
  }
}
