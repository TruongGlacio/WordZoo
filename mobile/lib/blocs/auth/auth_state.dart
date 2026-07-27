part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserProfile user;
  final bool isPremium;
  const Authenticated({required this.user, required this.isPremium});

  Authenticated copyWith({UserProfile? user, bool? isPremium}) {
    return Authenticated(
      user: user ?? this.user,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  List<Object?> get props => [user, isPremium];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
