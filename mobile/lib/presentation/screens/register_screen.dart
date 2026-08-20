import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/generated/assets.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import '../../utils/notification_service.dart';
import 'package:wordzoo/generated/l10n.dart';
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
          decoration:  BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.assets.background.loginLandScape.path), fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
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
                                      labelText: S().displayName,
                                      prefixIcon: const Icon(Icons.person,color:AppColors.earthBrown),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      enabledBorder:  OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium),
                                          borderSide: const BorderSide(
                                            color: AppColors.brown,
                                          )),
                                      filled: true,
                                      fillColor: AppColors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return S().displayNameRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  Gap(SizeManager().spacing16),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: S().email,
                                      prefixIcon: const Icon(Icons.email,color:AppColors.earthBrown),
                                      enabledBorder:  OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium),
                                          borderSide: const BorderSide(
                                            color: AppColors.brown,
                                          )),
                                      filled: true,
                                      fillColor: AppColors.white,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return S().emailRequired;
                                      }
                                      if (!value.contains('@')) {
                                        return S().invalidEmail;
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
                                      labelText: S().password,
                                      prefixIcon: const Icon(Icons.lock,color:AppColors.earthBrown),
                                      enabledBorder:  OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium),
                                          borderSide: const BorderSide(
                                            color: AppColors.brown,
                                          )),
                                      filled: true,
                                      fillColor: AppColors.white,
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return S().passwordRequired;
                                      }
                                      if (value.length < 6) {
                                        return S().passwordTooShort;
                                      }
                                      return null;
                                    },
                                  ),
                                  Gap(SizeManager().spacing16),
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    decoration: InputDecoration(
                                      labelText: S().confirmPassword,
                                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.earthBrown),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium),
                                        borderSide: const BorderSide(
                                          color: AppColors.brown,
                                        )),
                                      filled: true,
                                      fillColor: AppColors.white,
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return S().confirmPasswordRequired;
                                      }
                                      if (value != passwordController.text) {
                                        return S().passwordMismatch;
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 250,
                              child: ElevatedButton(
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
                                child: Text(S().signUp),
                              ),
                            ),
                          ],
                        ),
                        Gap(SizeManager().spacing16),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 250
                              ),
                              decoration:  const BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.white,
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    S().alreadyHaveAccount,
                                    style: AppTextStyles.body,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      S().signIn,
                                      style: const TextStyle(
                                        color: AppColors.oceanBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
