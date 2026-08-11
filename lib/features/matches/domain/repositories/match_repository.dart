import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/match.dart';

abstract class MatchRepository {
  Future<Either<Failure, List<Match>>> getMatches({String? competition, String? dateFrom, String? dateTo, String? status});
  Future<Either<Failure, Match>> getMatchDetails(String matchId);
  Future<Either<Failure, List<Match>>> getLiveMatches();
  Future<Either<Failure, List<Match>>> getFeaturedMatches();
  Future<Either<Failure, List<Match>>> getMatchesByCompetition(String competitionId);
  Future<Either<Failure, List<Match>>> getMatchesByDate(DateTime date);

  Future<Either<Failure, List<Prediction>>> getUserPredictions(String userId, {String? matchId});
  Future<Either<Failure, Prediction>> makePrediction(Prediction prediction);
  Future<Either<Failure, void>> cancelPrediction(String predictionId);
  Future<Either<Failure, List<Prediction>>> getMatchPredictions(String matchId);

  Stream<Either<Failure, Match>> watchLiveMatch(String matchId);
}
