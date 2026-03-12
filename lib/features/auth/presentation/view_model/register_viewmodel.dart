import 'package:book_store/features/auth/presentation/models/register_state.dart';
import 'package:book_store/features/auth/presentation/view_model/register_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';

class RegisterCubit extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _repository;

  RegisterCubit(this._repository) : super(RegisterState()) {
    on<RegisterSubmittedEvent>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmittedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterState(isLoading: true));

    try {
      await _repository.register(email: event.email, password: event.password);
      emit(RegisterState(isSuccess: true));
    } on FirebaseAuthException catch (e) {
      emit(RegisterState(errorMessage: e.message));
    } catch (e) {
      emit(RegisterState(errorMessage: 'Something went wrong'));
    }
  }
}
