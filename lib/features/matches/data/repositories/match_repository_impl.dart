import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/match.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_remote_datasource.dart';
import '../models/match_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MatchRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Match>>> getMatches({String? competition, String? dateFrom, String? dateTo, String? status}) async {
    try {
      final matches = await remoteDataSource.getMatches(
        competition: competition,
        dateFrom: dateFrom,
        dateTo: dateTo,
        status: status,
      );
      return Right(matches);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Match>> getMatchDetails(String matchId) async {
    try {
      final match = await remoteDataSource.getMatchDetails(matchId);
      return Right(match);
    } catch (e) {
      return Left(NotFoundFailure('Match not found'));
    }
  }

  @override
  Future<Either<Failure, List<Match>>> getLiveMatches() async {
    try {
      final matches = await remoteDataSource.getLiveMatches();
      return Right(matches);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Match>>> getFeaturedMatches() async {
    try {
      final matches = await remoteDataSource.getFeaturedMatches();
      return Right(matches);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Match>>> getMatchesByCompetition(String competitionId) async {
    return getMatches(competition: competitionId);
  }

  @override
  Future<Either<Failure, List<Match>>> getMatchesByDate(DateTime date) async {
    try {
      final matches = await remoteDataSource.getMatchesByDate(date);
      return Right(matches);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Prediction>>> getUserPredictions(String userId, {String? matchId}) async {
    try {
      final predictions = await remoteDataSource.getUserPredictions(userId, matchId: matchId);
      return Right(predictions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Prediction>> makePrediction(Prediction prediction) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final model = PredictionModel(
        id: prediction.id,
        matchId: prediction.matchId,
        userId: prediction.userId,
        predictionType: prediction.predictionType,
        value: prediction.value,
        potentialPoints: prediction.potentialPoints,
        createdAt: prediction.createdAt,
        leagueId: prediction.leagueId,
      );
      final result = await remoteDataSource.makePrediction(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelPrediction(String predictionId) async {
    try {
      await remoteDataSource.cancelPrediction(predictionId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Prediction>>> getMatchPredictions(String matchId) async {
    try {
      final predictions = await remoteDataSource.getMatchPredictions(matchId);
      return Right(predictions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Match>> watchLiveMatch(String matchId) {
    return remoteDataSource.watchLiveMatch(matchId).map(
      (match) => Right<Failure, Match>(match),
    ).handleError(
      (error) => Left<Failure, Match>(ServerFailure(error.toString())),
    );
  }
}
