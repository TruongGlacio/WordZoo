import 'package:flutter/material.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';

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
              const SizedBox(height: 24),
              const Text(
                'WordZoo',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 48),
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
