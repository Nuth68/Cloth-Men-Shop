abstract class AuthEvent {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const RegisterEvent({required this.name, required this.email, required this.password});
}

class LogoutEvent extends AuthEvent {}
