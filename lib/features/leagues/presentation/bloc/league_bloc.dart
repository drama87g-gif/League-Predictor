import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/league.dart';
import '../../domain/usecases/league_usecases.dart';
import '../../../../core/usecases/usecase.dart';

part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  final GetPublicLeagues getPublicLeagues;
  final GetUserLeagues getUserLeagues;
  final GetLeagueDetails getLeagueDetails;
  final CreateLeague createLeague;
  final JoinLeague joinLeague;
  final GetLeagueLeaderboard getLeagueLeaderboard;

  LeagueBloc({
    required this.getPublicLeagues,
    required this.getUserLeagues,
    required this.getLeagueDetails,
    required this.createLeague,
    required this.joinLeague,
    required this.getLeagueLeaderboard,
  }) : super(LeagueInitial()) {
    on<LoadPublicLeagues>(_onLoadPublic);
    on<LoadUserLeagues>(_onLoadUser);
    on<LoadLeagueDetails>(_onLoadDetails);
    on<CreateLeagueEvent>(_onCreate);
    on<JoinLeagueEvent>(_onJoin);
    on<LoadLeagueLeaderboard>(_onLoadLeaderboard);
  }

  Future<void> _onLoadPublic(LoadPublicLeagues event, Emitter<LeagueState> emit) async {
    emit(LeagueLoading());
    final result = await getPublicLeagues(const NoParams());
    result.fold(
      (failure) => emit(LeagueError(failure.message)),
      (leagues) => emit(PublicLeaguesLoaded(leagues)),
    );
  }

  Future<void> _onLoadUser(LoadUserLeagues event, Emitter<LeagueState> emit) async {
    emit(LeagueLoading());
    final result = await getUserLeagues(event.userId);
    result.fold(
      (failure) => emit(LeagueError(failure.message)),
      (leagues) => emit(UserLeaguesLoaded(leagues)),
    );
  }

  Future<void> _onLoadDetails(LoadLeagueDetails event, Emitter<LeagueState> emit) async {
    emit(LeagueLoading());
    final result = await getLeagueDetails(event.leagueId);
    result.fold(
      (failure) => emit(LeagueError(failure.message)),
      (league) => emit(LeagueDetailsLoaded(league)),
    );
  }

  Future<void> _onCreate(CreateLeagueEvent event, Emitter<LeagueState> emit) async {
    emit(LeagueLoading());
    final result = await createLeague(event.league);
    result.fold(
      (failure) => emit(LeagueError(failure.message)),
      (league) => emit(LeagueCreated(league)),
    );
  }

  Future<void> _onJoin(JoinLeagueEvent event, Emitter<LeagueState> emit) async {
    emit(LeagueLoading());
    final result = await joinLeague(JoinLeagueParams(
      leagueId: event.leagueId,
      userId: event.userId,
      inviteCode: event.inviteCode,
    ));
    result.fold(
      (failure) => emit(LeagueError(failure.message)),
      (_) => emit(LeagueJoined()),
    );
  }

  Future<void> _onLoadLeaderboard(LoadLeagueLeaderboard event, Emitter<LeagueState> emit) async {
    emit(LeagueLoading());
    final result = await getLeagueLeaderboard(event.leagueId);
    result.fold(
      (failure) => emit(LeagueError(failure.message)),
      (members) => emit(LeagueLeaderboardLoaded(members)),
    );
  }
}
