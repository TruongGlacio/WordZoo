part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  const RegisterRequested(this.email, this.password, this.displayName);
  @override
  List<Object?> get props => [email, password, displayName];
}

class GuestModeRequested extends AuthEvent {
  const GuestModeRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged();
}
