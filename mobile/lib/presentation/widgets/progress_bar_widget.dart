import 'package:flutter/material.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';

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
        Text(
          '$learned/$total',
          style: AppTextStyles.small,
        ),
        SizedBox(height: SizeManager.instance.spacingSmall),
        LinearProgressIndicator(
          value: progress,
          minHeight: SizeManager.instance.spacingSmall,
          borderRadius: BorderRadius.circular(SizeManager.instance.borderRadiusSmall),
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.leafGreen),
        ),
      ],
    );
  }
}
