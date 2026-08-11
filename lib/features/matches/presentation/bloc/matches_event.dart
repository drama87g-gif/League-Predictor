part of 'matches_bloc.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();
  @override
  List<Object?> get props => [];
}

class LoadMatches extends MatchesEvent {
  final String? competition;
  final String? dateFrom;
  final String? dateTo;
  final String? status;
  const LoadMatches({this.competition, this.dateFrom, this.dateTo, this.status});
  @override
  List<Object?> get props => [competition, dateFrom, dateTo, status];
}

class LoadLiveMatches extends MatchesEvent {}

class LoadFeaturedMatches extends MatchesEvent {}

class LoadMatchDetails extends MatchesEvent {
  final String matchId;
  const LoadMatchDetails(this.matchId);
  @override
  List<Object?> get props => [matchId];
}

class FilterMatchesByCompetition extends MatchesEvent {
  final String competitionId;
  const FilterMatchesByCompetition(this.competitionId);
  @override
  List<Object?> get props => [competitionId];
}

class FilterMatchesByDate extends MatchesEvent {
  final DateTime date;
  const FilterMatchesByDate(this.date);
  @override
  List<Object?> get props => [date];
}

class SubmitPrediction extends MatchesEvent {
  final Prediction prediction;
  const SubmitPrediction(this.prediction);
  @override
  List<Object?> get props => [prediction];
}

class LoadUserPredictions extends MatchesEvent {
  final String userId;
  final String? matchId;
  const LoadUserPredictions({required this.userId, this.matchId});
  @override
  List<Object?> get props => [userId, matchId];
}

class WatchLiveMatchEvent extends MatchesEvent {
  final String matchId;
  const WatchLiveMatchEvent(this.matchId);
  @override
  List<Object?> get props => [matchId];
}

class LiveMatchUpdated extends MatchesEvent {
  final Either<Failure, Match> result;
  const LiveMatchUpdated(this.result);
  @override
  List<Object?> get props => [result];
}
