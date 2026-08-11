part of 'league_bloc.dart';

abstract class LeagueState extends Equatable {
  const LeagueState();
  @override
  List<Object?> get props => [];
}

class LeagueInitial extends LeagueState {}
class LeagueLoading extends LeagueState {}

class PublicLeaguesLoaded extends LeagueState {
  final List<League> leagues;
  const PublicLeaguesLoaded(this.leagues);
  @override
  List<Object?> get props => [leagues];
}

class UserLeaguesLoaded extends LeagueState {
  final List<League> leagues;
  const UserLeaguesLoaded(this.leagues);
  @override
  List<Object?> get props => [leagues];
}

class LeagueDetailsLoaded extends LeagueState {
  final League league;
  const LeagueDetailsLoaded(this.league);
  @override
  List<Object?> get props => [league];
}

class LeagueCreated extends LeagueState {
  final League league;
  const LeagueCreated(this.league);
  @override
  List<Object?> get props => [league];
}

class LeagueJoined extends LeagueState {}

class LeagueLeaderboardLoaded extends LeagueState {
  final List<LeagueMember> members;
  const LeagueLeaderboardLoaded(this.members);
  @override
  List<Object?> get props => [members];
}

class LeagueError extends LeagueState {
  final String message;
  const LeagueError(this.message);
  @override
  List<Object?> get props => [message];
}
