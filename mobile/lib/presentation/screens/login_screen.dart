import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradientSkyGrass,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 80, color: AppColors.leafGreen),
                  const SizedBox(height: 24),
                  const Text('WordZoo', style: AppTextStyles.heading),
                  const SizedBox(height: 48),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            LoginRequested(
                              emailController.text,
                              passwordController.text,
                            ),
                          );
                    },
                    child: const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            RegisterRequested(
                              emailController.text,
                              passwordController.text,
                              emailController.text.split('@')[0],
                            ),
                          );
                    },
                    child: const Text('Đăng ký'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const GuestModeRequested());
                    },
                    child: const Text('Khách (Guest)'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
