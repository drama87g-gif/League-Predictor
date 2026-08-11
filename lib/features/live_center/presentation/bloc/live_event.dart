part of 'live_center_bloc.dart';

abstract class LiveCenterEvent extends Equatable {
  const LiveCenterEvent();
  @override
  List<Object?> get props => [];
}

class WatchLiveMatch extends LiveCenterEvent {
  final String matchId;
  const WatchLiveMatch(this.matchId);
  @override
  List<Object?> get props => [matchId];
}

class LiveMatchUpdated extends LiveCenterEvent {
  final LiveMatchState state;
  const LiveMatchUpdated(this.state);
  @override
  List<Object?> get props => [state];
}

class LoadMatchEvents extends LiveCenterEvent {
  final String matchId;
  const LoadMatchEvents(this.matchId);
  @override
  List<Object?> get props => [matchId];
}
