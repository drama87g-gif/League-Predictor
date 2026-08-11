import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/match.dart';
import '../repositories/match_repository.dart';

class GetMatches implements UseCase<List<Match>, GetMatchesParams> {
  final MatchRepository repository;
  GetMatches(this.repository);

  @override
  Future<Either<Failure, List<Match>>> call(GetMatchesParams params) {
    return repository.getMatches(
      competition: params.competition,
      dateFrom: params.dateFrom,
      dateTo: params.dateTo,
      status: params.status,
    );
  }
}

class GetMatchDetails implements UseCase<Match, String> {
  final MatchRepository repository;
  GetMatchDetails(this.repository);

  @override
  Future<Either<Failure, Match>> call(String matchId) {
    return repository.getMatchDetails(matchId);
  }
}

class GetLiveMatches implements UseCase<List<Match>, NoParams> {
  final MatchRepository repository;
  GetLiveMatches(this.repository);

  @override
  Future<Either<Failure, List<Match>>> call(NoParams params) {
    return repository.getLiveMatches();
  }
}

class GetFeaturedMatches implements UseCase<List<Match>, NoParams> {
  final MatchRepository repository;
  GetFeaturedMatches(this.repository);

  @override
  Future<Either<Failure, List<Match>>> call(NoParams params) {
    return repository.getFeaturedMatches();
  }
}

class MakePrediction implements UseCase<Prediction, Prediction> {
  final MatchRepository repository;
  MakePrediction(this.repository);

  @override
  Future<Either<Failure, Prediction>> call(Prediction prediction) {
    return repository.makePrediction(prediction);
  }
}

class GetUserPredictions implements UseCase<List<Prediction>, GetUserPredictionsParams> {
  final MatchRepository repository;
  GetUserPredictions(this.repository);

  @override
  Future<Either<Failure, List<Prediction>>> call(GetUserPredictionsParams params) {
    return repository.getUserPredictions(params.userId, matchId: params.matchId);
  }
}

class WatchLiveMatch extends StreamUseCase<Match, String> {
  final MatchRepository repository;
  WatchLiveMatch(this.repository);

  @override
  Stream<Either<Failure, Match>> call(String matchId) {
    return repository.watchLiveMatch(matchId);
  }
}

class GetMatchesParams {
  final String? competition;
  final String? dateFrom;
  final String? dateTo;
  final String? status;

  GetMatchesParams({this.competition, this.dateFrom, this.dateTo, this.status});
}

class GetUserPredictionsParams {
  final String userId;
  final String? matchId;

  GetUserPredictionsParams({required this.userId, this.matchId});
}
