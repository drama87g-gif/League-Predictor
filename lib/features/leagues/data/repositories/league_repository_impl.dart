import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/league.dart';
import '../../domain/repositories/league_repository.dart';
import '../datasources/league_remote_datasource.dart';
import '../models/league_model.dart';

class LeagueRepositoryImpl implements LeagueRepository {
  final LeagueRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LeagueRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<League>>> getPublicLeagues() async {
    try {
      final leagues = await remoteDataSource.getPublicLeagues();
      return Right(leagues);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<League>>> getUserLeagues(String userId) async {
    try {
      final leagues = await remoteDataSource.getUserLeagues(userId);
      return Right(leagues);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, League>> getLeagueDetails(String leagueId) async {
    try {
      final league = await remoteDataSource.getLeagueDetails(leagueId);
      return Right(league);
    } catch (e) {
      return Left(NotFoundFailure('League not found'));
    }
  }

  @override
  Future<Either<Failure, League>> createLeague(League league) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = LeagueModel(
        id: league.id,
        name: league.name,
        description: league.description,
        ownerId: league.ownerId,
        scoringRules: league.scoringRules,
        createdAt: league.createdAt,
        isPublic: league.isPublic,
        season: league.season,
        competitionFilter: league.competitionFilter,
        imageUrl: league.imageUrl,
        maxMembers: league.maxMembers,
      );
      final result = await remoteDataSource.createLeague(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinLeague(String leagueId, String userId, {String? inviteCode}) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.joinLeague(leagueId, userId, inviteCode: inviteCode);
      return const Right(null);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveLeague(String leagueId, String userId) async {
    try {
      await remoteDataSource.leaveLeague(leagueId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLeague(League league) async {
    try {
      await remoteDataSource.updateLeague(LeagueModel(
        id: league.id,
        name: league.name,
        description: league.description,
        ownerId: league.ownerId,
        memberIds: league.memberIds,
        scoringRules: league.scoringRules,
        createdAt: league.createdAt,
        isPublic: league.isPublic,
        inviteCode: league.inviteCode,
        season: league.season,
        competitionFilter: league.competitionFilter,
        imageUrl: league.imageUrl,
        maxMembers: league.maxMembers,
      ));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLeague(String leagueId) async {
    try {
      await remoteDataSource.deleteLeague(leagueId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeagueMember>>> getLeagueLeaderboard(String leagueId) async {
    try {
      final members = await remoteDataSource.getLeagueLeaderboard(leagueId);
      return Right(members);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateInviteCode(String leagueId) async {
    try {
      final code = await remoteDataSource.generateInviteCode(leagueId);
      return Right(code);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
