import 'package:book_store/core/constants/app_assets.dart';
import 'package:book_store/core/constants/values_manager.dart';
import 'package:book_store/features/auth/data/auth_repository.dart';
import 'package:book_store/features/auth/presentation/view_model/register_viewmodel.dart';
import 'package:book_store/features/auth/presentation/widgets/register_form.dart';
import 'package:book_store/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.register)),
      body: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) => RegisterViewModel(context.read<AuthRepository>()),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p20),
              child: Column(
                children: [
                  Image.asset(AppAssets.bookIcon, height: AppSize.s200),
                  const SizedBox(height: AppSize.s20),
                  const RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
