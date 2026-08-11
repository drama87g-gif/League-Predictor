import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmail implements UseCase<User, SignInParams> {
  final AuthRepository repository;
  SignInWithEmail(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    return repository.signInWithEmail(params.email, params.password);
  }
}

class SignUpWithEmail implements UseCase<User, SignUpParams> {
  final AuthRepository repository;
  SignUpWithEmail(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    return repository.signUpWithEmail(params.email, params.password, params.displayName);
  }
}

class SignInWithGoogle implements UseCase<User, NoParams> {
  final AuthRepository repository;
  SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}

class SignInWithApple implements UseCase<User, NoParams> {
  final AuthRepository repository;
  SignInWithApple(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.signInWithApple();
  }
}

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;
  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}

class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}

class UpdateProfile implements UseCase<void, UpdateProfileParams> {
  final AuthRepository repository;
  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.user);
  }
}

class SignInParams {
  final String email;
  final String password;
  SignInParams({required this.email, required this.password});
}

class SignUpParams {
  final String email;
  final String password;
  final String displayName;
  SignUpParams({required this.email, required this.password, required this.displayName});
}

class UpdateProfileParams {
  final User user;
  UpdateProfileParams({required this.user});
}
