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
        resizeToAvoidBottomInset: true,
        extendBody: true,
        appBar: null,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(image: AssetImage(Assets.assets.background.loginLandScape.path), fit: BoxFit.cover),
          ),
          child: Padding(
            padding:  SizeManager().paddingMedium,
            child: Center(
              child: ConstrainedBox(
                constraints:  BoxConstraints(maxWidth: SizeManager().size350),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: S().displayName,
                          prefixIcon: const Icon(Icons.face, color:AppColors.earthBrown),
                          enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(SizeManager().borderRadiusMedium),
                              borderSide: const BorderSide(
                                  color: AppColors.brown,
                              ))
                        ),
                      ),
                      Gap(SizeManager().spacing32),
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
                            style:  ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(SizeManager().imageXXXLarge, SizeManager().imageSmall))
                            ),
                            child: Text(S().playNow),
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
    );
  }
}
