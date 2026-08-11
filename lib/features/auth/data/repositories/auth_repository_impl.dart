import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, User>> signInWithEmail(String email, String password) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.signInWithEmail(email, password);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail(String email, String password, String displayName) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.signUpWithEmail(email, password, displayName);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await remoteDataSource.signInWithApple();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(User user) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.updateUserData(UserModel(
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        country: user.country,
        favoriteClub: user.favoriteClub,
        favoriteNationalTeam: user.favoriteNationalTeam,
        xp: user.xp,
        coins: user.coins,
        level: user.level,
        isPremium: user.isPremium,
        premiumExpiry: user.premiumExpiry,
        createdAt: user.createdAt,
        lastActive: user.lastActive,
        achievements: user.achievements,
        stats: user.stats,
        fcmTokens: user.fcmTokens,
      ));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String currentPassword, String newPassword) async {
    return const Right(null); // Implementation depends on Firebase re-authentication
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      // await remoteDataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        await remoteDataSource.deleteUser(user.id);
      }
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }
}
