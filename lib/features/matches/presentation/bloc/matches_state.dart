part of 'matches_bloc.dart';

abstract class MatchesState extends Equatable {
  const MatchesState();
  @override
  List<Object?> get props => [];
}

class MatchesInitial extends MatchesState {}
class MatchesLoading extends MatchesState {}
class MatchDetailsLoading extends MatchesState {}
class PredictionSubmitting extends MatchesState {}

class MatchesLoaded extends MatchesState {
  final List<Match> matches;
  final String? filter;
  final DateTime? selectedDate;
  const MatchesLoaded(this.matches, {this.filter, this.selectedDate});
  @override
  List<Object?> get props => [matches, filter, selectedDate];
}

class LiveMatchesLoaded extends MatchesState {
  final List<Match> matches;
  const LiveMatchesLoaded(this.matches);
  @override
  List<Object?> get props => [matches];
}

class FeaturedMatchesLoaded extends MatchesState {
  final List<Match> matches;
  const FeaturedMatchesLoaded(this.matches);
  @override
  List<Object?> get props => [matches];
}

class MatchDetailsLoaded extends MatchesState {
  final Match match;
  const MatchDetailsLoaded(this.match);
  @override
  List<Object?> get props => [match];
}

class UserPredictionsLoaded extends MatchesState {
  final List<Prediction> predictions;
  const UserPredictionsLoaded(this.predictions);
  @override
  List<Object?> get props => [predictions];
}

class PredictionSubmitted extends MatchesState {
  final Prediction prediction;
  const PredictionSubmitted(this.prediction);
  @override
  List<Object?> get props => [prediction];
}

class LiveMatchUpdatedState extends MatchesState {
  final Match match;
  const LiveMatchUpdatedState(this.match);
  @override
  List<Object?> get props => [match];
}

class MatchesError extends MatchesState {
  final String message;
  const MatchesError(this.message);
  @override
  List<Object?> get props => [message];
}

class PredictionError extends MatchesState {
  final String message;
  const PredictionError(this.message);
  @override
  List<Object?> get props => [message];
}
