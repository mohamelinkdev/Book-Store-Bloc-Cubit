sealed class RegisterEvent {}

class RegisterSubmittedEvent extends RegisterEvent {
  final String email;
  final String password;

  RegisterSubmittedEvent({required this.email, required this.password});
}
