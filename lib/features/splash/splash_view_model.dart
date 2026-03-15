import 'package:book_store/features/splash/model/splash_state.dart';
import 'package:book_store/features/splash/splash_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashStatus> {
  SplashViewModel() : super(SplashStatus.initial) {
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<SplashStatus> emit,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      emit(SplashStatus.authenticated);
    } else {
      emit(SplashStatus.unauthenticated);
    }
  }
}
