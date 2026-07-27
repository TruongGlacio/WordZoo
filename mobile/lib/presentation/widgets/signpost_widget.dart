import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';

class SignpostWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SignpostWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.earthBrown,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.earthBrown, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.softShadow,
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.signpost,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms);
  }
}
