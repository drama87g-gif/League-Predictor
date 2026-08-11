part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class SignInEmailRequested extends AuthEvent {
  final String email;
  final String password;
  const SignInEmailRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  const SignUpEmailRequested({required this.email, required this.password, required this.displayName});

  @override
  List<Object?> get props => [email, password, displayName];
}

class SignInGoogleRequested extends AuthEvent {}

class SignInAppleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class ProfileUpdateRequested extends AuthEvent {
  final User user;
  const ProfileUpdateRequested({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthStateChanged extends AuthEvent {
  final User? user;
  const AuthStateChanged({this.user});

  @override
  List<Object?> get props => [user];
}
