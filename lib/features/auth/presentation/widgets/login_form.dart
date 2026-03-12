import 'package:book_store/core/constants/values_manager.dart';
import 'package:book_store/core/utils/app_loader.dart';
import 'package:book_store/core/utils/app_validator.dart';
import 'package:book_store/core/widgets/app_button.dart';
import 'package:book_store/core/widgets/app_text_form_field.dart';
import 'package:book_store/features/auth/presentation/view_model/login_viewmodel.dart';
import 'package:book_store/features/auth/presentation/view_model/login_event.dart';
import 'package:book_store/features/auth/presentation/models/login_state.dart';
import 'package:book_store/features/auth/presentation/screens/register_screen.dart';
import 'package:book_store/features/home/presentation/screens/home_screen.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocConsumer<LoginViewModel, LoginState>(
      listenWhen: (previous, current) {
        return previous.isLoading != current.isLoading || 
               current.isSuccess || 
               current.errorMessage != null;
      },
      listener: (context, state) {
        if (state.isLoading) {
          AppLoader.show(context);
        } else {
          AppLoader.hide(context);
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }

        if (state.isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextFormField(
                controller: emailController,
                labelText: l10n.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterEmail;
                  }
                  if (!AppValidator.isEmailValid(value.trim())) {
                    return l10n.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSize.s20),
              AppTextFormField(
                controller: passwordController,
                labelText: l10n.password,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterPassword;
                  }
                  if (!AppValidator.isPasswordValid(value.trim())) {
                    return l10n.passwordMinLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSize.s20),
              AppButton(
                text: l10n.login,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginViewModel>().add(LoginSubmittedEvent(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ));
                  }
                },
              ),
              const SizedBox(height: AppSize.s20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: Text(l10n.dontHaveAccount),
              ),
            ],
          ),
        );
      },
    );
  }
}
