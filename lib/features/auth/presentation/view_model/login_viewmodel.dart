import 'package:book_store/features/auth/presentation/models/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';

class LoginViewModel extends Cubit<LoginState> {
  final AuthRepository _repository;

  LoginViewModel(this._repository) : super(LoginState());

  Future<void> login(String email, String password) async {
    emit(LoginState(isLoading: true));

    try {
      await _repository.login(email: email, password: password);
      emit(LoginState(isSuccess: true));
    } on FirebaseAuthException catch (e) {
      emit(LoginState(errorMessage: e.message));
    } catch (e) {
      emit(LoginState(errorMessage: 'Something went wrong'));
    }
  }
}
