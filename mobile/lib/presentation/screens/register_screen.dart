import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import '../../utils/notification_service.dart';
import 'package:wordzoo/l10n/app_localizations.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final displayNameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pop();
        } else if (state is AuthError) {
          NotificationService.instance.show(
            context,
            state.message,
            type: NotificationType.error,
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.gradientSkyGrass,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Gap(SizeManager().spacing32),
                        const Icon(
                          Icons.pets,
                          size: 80,
                          color: AppColors.earthBrown,
                        ),
                        Gap(SizeManager().spacing16),
                        Text(
                          AppLocalizations.of(context)!.appName,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title,
                        ),
                        Gap(SizeManager().spacing8),
                        Text(
                          AppLocalizations.of(context)!.subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body,
                        ),
                        Gap(SizeManager().spacing32),
                      ],
                    ),
                    Gap(SizeManager().spacing32),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: displayNameController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.displayName,
                                        prefixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.white,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return AppLocalizations.of(context)!.displayNameRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(SizeManager().spacing16),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.email,
                                        prefixIcon: const Icon(Icons.email),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.white,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return AppLocalizations.of(context)!.emailRequired;
                                        }
                                        if (!value.contains('@')) {
                                          return AppLocalizations.of(context)!.invalidEmail;
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(SizeManager().spacing16),
                                  ],
                                ),
                              ),
                              Gap(SizeManager().spacing32),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.password,
                                        prefixIcon: const Icon(Icons.lock),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.white,
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return AppLocalizations.of(context)!.passwordRequired;
                                        }
                                        if (value.length < 6) {
                                          return AppLocalizations.of(context)!.passwordTooShort;
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(SizeManager().spacing16),
                                    TextFormField(
                                      controller: confirmPasswordController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!.confirmPassword,
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.white,
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return AppLocalizations.of(context)!.confirmPasswordRequired;
                                        }
                                        if (value != passwordController.text) {
                                          return AppLocalizations.of(context)!.passwordMismatch;
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(SizeManager().spacing16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(SizeManager().spacing16),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      RegisterRequested(
                                        emailController.text.trim(),
                                        passwordController.text,
                                        displayNameController.text.trim(),
                                      ),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.leafGreen,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.signUp),
                          ),
                          Gap(SizeManager().spacing16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.alreadyHaveAccount,
                                style: AppTextStyles.body,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.signIn,
                                  style: TextStyle(
                                    color: AppColors.leafGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
