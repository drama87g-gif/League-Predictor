import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../../../core/usecases/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final UpdateProfile updateProfile;

  StreamSubscription? _authSubscription;

  AuthBloc({
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.signOut,
    required this.getCurrentUser,
    required this.updateProfile,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInEmailRequested>(_onSignInEmail);
    on<SignUpEmailRequested>(_onSignUpEmail);
    on<SignInGoogleRequested>(_onSignInGoogle);
    on<SignInAppleRequested>(_onSignInApple);
    on<SignOutRequested>(_onSignOut);
    on<ProfileUpdateRequested>(_onUpdateProfile);
    on<AuthStateChanged>(_onAuthStateChanged);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(Unauthenticated(message: failure.message)),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInEmail(SignInEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithEmail(SignInParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignUpEmail(SignUpEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpWithEmail(
      SignUpParams(email: event.email, password: event.password, displayName: event.displayName),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInGoogle(SignInGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInApple(SignInAppleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithApple(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOut(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signOut(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onUpdateProfile(ProfileUpdateRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await updateProfile(UpdateProfileParams(user: event.user));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(ProfileUpdated(event.user)),
    );
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(const Unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
