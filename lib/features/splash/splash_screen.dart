import 'package:book_store/core/constants/app_assets.dart';
import 'package:book_store/core/theme/app_colors.dart';
import 'package:book_store/features/auth/presentation/screens/login_screen.dart';
import 'package:book_store/features/home/presentation/screens/home_screen.dart';
import 'package:book_store/features/splash/model/splash_state.dart';
import 'package:book_store/features/splash/splash_view_model.dart';
import 'package:book_store/features/splash/splash_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashViewModel()..add(CheckAuthEvent()),
      child: BlocListener<SplashViewModel, SplashStatus>(
        listener: (context, state) {
          if (state == SplashStatus.authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state == SplashStatus.unauthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: Center(
            child: Image.asset(
              AppAssets.bookIcon,
              height: 100,
              width: 100,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
