import 'package:book_store/features/auth/presentation/models/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';

class RegisterViewModel extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterViewModel(this._repository) : super(RegisterState());

  Future<void> register(String email, String password) async {
    emit(RegisterState(isLoading: true));

    try {
      await _repository.register(email: email, password: password);
      emit(RegisterState(isSuccess: true));
    } on FirebaseAuthException catch (e) {
      emit(RegisterState(errorMessage: e.message));
    } catch (e) {
      emit(RegisterState(errorMessage: 'Something went wrong'));
    }
  }
}
