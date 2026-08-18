part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String name;
  final String password;
  const LoginRequested(this.name, this.password);
  @override
  List<Object?> get props => [name, password];
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
class LoadingDataProcess extends AuthEvent {
  const LoadingDataProcess();
}
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthStatusChanged extends AuthEvent {
  const AuthStatusChanged();
}
