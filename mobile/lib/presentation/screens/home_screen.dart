import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import 'package:wordzoo/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated
        ? (authState.user.displayName ?? 'bạn nhỏ')
        : 'bạn nhỏ';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradientSkyGrass,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.appName,
                      style: AppTextStyles.title,
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const LogoutRequested());
                      },
                      icon: const Icon(Icons.logout, color: AppColors.darkText),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Xin chào, $userName!', style: AppTextStyles.body),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.todayIsNewDay,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    children: [
                      _CategoryCard(
                        icon: Icons.pets,
                        title: AppLocalizations.of(context)!.animals,
                        color: AppColors.leafGreen,
                        onTap: () {
                          // Navigate to Animal World
                        },
                      ),
                      _CategoryCard(
                        icon: Icons.eco,
                        title: AppLocalizations.of(context)!.plants,
                        color: AppColors.grassGreen,
                        onTap: () {
                          // Navigate to Plant World
                        },
                      ),
                      _CategoryCard(
                        icon: Icons.directions_car,
                        title: AppLocalizations.of(context)!.vehicles,
                        color: AppColors.oceanBlue,
                        onTap: () {
                          // Navigate to Vehicle World
                        },
                      ),
                      _CategoryCard(
                        icon: Icons.people,
                        title: AppLocalizations.of(context)!.humanRelations,
                        color: AppColors.earthBrown,
                        onTap: () {
                          // Navigate to Human Relations
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 64, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: SizeManager.instance.titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 200.ms);
  }
}
