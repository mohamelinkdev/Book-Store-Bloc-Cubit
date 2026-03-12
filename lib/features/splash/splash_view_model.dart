import 'package:book_store/features/splash/model/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashViewModel extends Cubit<SplashStatus> {
  SplashViewModel() : super(SplashStatus.initial);

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      emit(SplashStatus.authenticated);
    } else {
      emit(SplashStatus.unauthenticated);
    }
  }
}
