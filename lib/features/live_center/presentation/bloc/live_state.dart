part of 'live_center_bloc.dart';

abstract class LiveCenterState extends Equatable {
  const LiveCenterState();
  @override
  List<Object?> get props => [];
}

class LiveCenterInitial extends LiveCenterState {}
class LiveCenterLoading extends LiveCenterState {}

class LiveMatchStateLoaded extends LiveCenterState {
  final LiveMatchState state;
  const LiveMatchStateLoaded(this.state);
  @override
  List<Object?> get props => [state];
}

class LiveEventsLoaded extends LiveCenterState {
  final List<LiveEvent> events;
  const LiveEventsLoaded(this.events);
  @override
  List<Object?> get props => [events];
}

class LiveCenterError extends LiveCenterState {
  final String message;
  const LiveCenterError(this.message);
  @override
  List<Object?> get props => [message];
}
