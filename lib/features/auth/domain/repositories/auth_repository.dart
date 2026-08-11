import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, User>> signUpWithEmail(String email, String password, String displayName);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithApple();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> updateProfile(User user);
  Future<Either<Failure, void>> updatePassword(String currentPassword, String newPassword);
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> deleteAccount();
  Stream<User?> get authStateChanges;
}
