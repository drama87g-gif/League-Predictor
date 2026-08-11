import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/match.dart';
import '../../domain/usecases/match_usecases.dart';
import '../../../../core/usecases/usecase.dart';

part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final GetMatches getMatches;
  final GetLiveMatches getLiveMatches;
  final GetFeaturedMatches getFeaturedMatches;
  final GetMatchDetails getMatchDetails;
  final MakePrediction makePrediction;
  final GetUserPredictions getUserPredictions;
  final WatchLiveMatch watchLiveMatch;

  StreamSubscription? _liveMatchSubscription;

  MatchesBloc({
    required this.getMatches,
    required this.getLiveMatches,
    required this.getFeaturedMatches,
    required this.getMatchDetails,
    required this.makePrediction,
    required this.getUserPredictions,
    required this.watchLiveMatch,
  }) : super(MatchesInitial()) {
    on<LoadMatches>(_onLoadMatches);
    on<LoadLiveMatches>(_onLoadLiveMatches);
    on<LoadFeaturedMatches>(_onLoadFeaturedMatches);
    on<LoadMatchDetails>(_onLoadMatchDetails);
    on<FilterMatchesByCompetition>(_onFilterByCompetition);
    on<FilterMatchesByDate>(_onFilterByDate);
    on<SubmitPrediction>(_onSubmitPrediction);
    on<LoadUserPredictions>(_onLoadUserPredictions);
    on<WatchLiveMatchEvent>(_onWatchLiveMatch);
    on<LiveMatchUpdated>(_onLiveMatchUpdated);
  }

  Future<void> _onLoadMatches(LoadMatches event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    final result = await getMatches(GetMatchesParams(
      competition: event.competition,
      dateFrom: event.dateFrom,
      dateTo: event.dateTo,
      status: event.status,
    ));
    result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (matches) => emit(MatchesLoaded(matches)),
    );
  }

  Future<void> _onLoadLiveMatches(LoadLiveMatches event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    final result = await getLiveMatches(const NoParams());
    result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (matches) => emit(LiveMatchesLoaded(matches)),
    );
  }

  Future<void> _onLoadFeaturedMatches(LoadFeaturedMatches event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    final result = await getFeaturedMatches(const NoParams());
    result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (matches) => emit(FeaturedMatchesLoaded(matches)),
    );
  }

  Future<void> _onLoadMatchDetails(LoadMatchDetails event, Emitter<MatchesState> emit) async {
    emit(MatchDetailsLoading());
    final result = await getMatchDetails(event.matchId);
    result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (match) => emit(MatchDetailsLoaded(match)),
    );
  }

  Future<void> _onFilterByCompetition(FilterMatchesByCompetition event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    final result = await getMatches(GetMatchesParams(competition: event.competitionId));
    result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (matches) => emit(MatchesLoaded(matches, filter: event.competitionId)),
    );
  }

  Future<void> _onFilterByDate(FilterMatchesByDate event, Emitter<MatchesState> emit) async {
    emit(MatchesLoading());
    final dateStr = event.date.toIso8601String().split('T')[0];
    final result = await getMatches(GetMatchesParams(dateFrom: dateStr, dateTo: dateStr));
    result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (matches) => emit(MatchesLoaded(matches, selectedDate: event.date)),
    );
  }

  Future<void> _onSubmitPrediction(SubmitPrediction event, Emitter<MatchesState> emit) async {
    emit(PredictionSubmitting());
    final result = await makePrediction(event.prediction);
    result.fold(
      (failure) => emit(PredictionError(failure.message)),
      (prediction) => emit(PredictionSubmitted(prediction)),
    );
  }

  Future<void> _onLoadUserPredictions(LoadUserPredictions event, Emitter<MatchesState> emit) async {
    final result = await getUserPredictions(GetUserPredictionsParams(
      userId: event.userId,
      matchId: event.matchId,
    ));
    result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (predictions) => emit(UserPredictionsLoaded(predictions)),
    );
  }

  void _onWatchLiveMatch(WatchLiveMatchEvent event, Emitter<MatchesState> emit) {
    _liveMatchSubscription?.cancel();
    _liveMatchSubscription = watchLiveMatch(event.matchId).listen(
      (result) => add(LiveMatchUpdated(result)),
    );
  }

  void _onLiveMatchUpdated(LiveMatchUpdated event, Emitter<MatchesState> emit) {
    event.result.fold(
      (failure) => emit(MatchesError(failure.message)),
      (match) => emit(LiveMatchUpdatedState(match)),
    );
  }

  @override
  Future<void> close() {
    _liveMatchSubscription?.cancel();
    return super.close();
  }
}
