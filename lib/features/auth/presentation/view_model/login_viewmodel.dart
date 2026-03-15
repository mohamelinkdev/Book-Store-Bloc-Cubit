import 'package:book_store/features/auth/presentation/models/login_state.dart';
import 'package:book_store/features/auth/presentation/view_model/login_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _repository;

  LoginViewModel(this._repository) : super(LoginState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginState(isLoading: true));

    try {
      await _repository.login(email: event.email, password: event.password);
      emit(LoginState(isSuccess: true));
    } on FirebaseAuthException catch (e) {
      emit(LoginState(errorMessage: e.message));
    } catch (e) {
      emit(LoginState(errorMessage: 'Something went wrong'));
    }
  }
}
