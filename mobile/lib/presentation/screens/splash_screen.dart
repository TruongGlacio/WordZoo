import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import 'package:wordzoo/l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradientSkyGrass,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
              Icon(
                Icons.pets,
                size: 120,
                color: AppColors.leafGreen,
              ),
              Gap(SizeManager().spacing24),
              Text(
                AppLocalizations.of(context)!.appName,
                style: AppTextStyles.heading,
              ),
              Gap(SizeManager().spacing48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.leafGreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
