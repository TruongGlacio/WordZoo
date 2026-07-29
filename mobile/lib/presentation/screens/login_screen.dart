import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';
import '../../utils/size_manager.dart';
import '../../utils/notification_service.dart';
import 'package:wordzoo/l10n/app_localizations.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.pets, size: 80, color: AppColors.leafGreen),
                        Gap(SizeManager().spacing24),
                        Text(
                          AppLocalizations.of(context)!.appName,
                          style: AppTextStyles.heading,
                        ),
                        Gap(SizeManager().spacing48),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.email,
                                prefixIcon: const Icon(Icons.email),
                              ),
                            ),
                            Gap(SizeManager().spacing16),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                prefixIcon: const Icon(Icons.lock),
                              ),
                            ),
                            Gap(SizeManager().spacing24),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                          LoginRequested(
                                            emailController.text,
                                            passwordController.text,
                                          ),
                                        );
                                  },
                                  style: const ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(Size(150, 50))
                                  ),
                                  child: Text(AppLocalizations.of(context)!.signIn),
                                ),
                                Gap(SizeManager().spacing12),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(AppColors.white),
                                      fixedSize: WidgetStatePropertyAll(Size(150, 50))
                                  ),
                                  child: Text(AppLocalizations.of(context)!.register, style: const TextStyle(color: AppColors.darkText),),
                                ),
                              ],
                            ),
                            Gap(SizeManager().spacing12),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(const GuestModeRequested());
                              },
                              style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(AppColors.sunnyYellow),
                                  fixedSize: WidgetStatePropertyAll(Size(250, 50))
                              ),
                              child: Text(AppLocalizations.of(context)!.guestMode,style: TextStyle(color: AppColors.coralRed),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
