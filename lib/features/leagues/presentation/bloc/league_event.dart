part of 'league_bloc.dart';

abstract class LeagueEvent extends Equatable {
  const LeagueEvent();
  @override
  List<Object?> get props => [];
}

class LoadPublicLeagues extends LeagueEvent {}

class LoadUserLeagues extends LeagueEvent {
  final String userId;
  const LoadUserLeagues(this.userId);
  @override
  List<Object?> get props => [userId];
}

class LoadLeagueDetails extends LeagueEvent {
  final String leagueId;
  const LoadLeagueDetails(this.leagueId);
  @override
  List<Object?> get props => [leagueId];
}

class CreateLeagueEvent extends LeagueEvent {
  final League league;
  const CreateLeagueEvent(this.league);
  @override
  List<Object?> get props => [league];
}

class JoinLeagueEvent extends LeagueEvent {
  final String leagueId;
  final String userId;
  final String? inviteCode;
  const JoinLeagueEvent({required this.leagueId, required this.userId, this.inviteCode});
  @override
  List<Object?> get props => [leagueId, userId, inviteCode];
}

class LoadLeagueLeaderboard extends LeagueEvent {
  final String leagueId;
  const LoadLeagueLeaderboard(this.leagueId);
  @override
  List<Object?> get props => [leagueId];
}
