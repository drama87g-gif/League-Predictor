import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/live_event.dart';
import '../../data/datasources/live_center_remote_datasource.dart';

part 'live_event.dart';
part 'live_state.dart';

class LiveCenterBloc extends Bloc<LiveCenterEvent, LiveCenterState> {
  final LiveCenterRemoteDataSource remoteDataSource;
  StreamSubscription? _matchSubscription;

  LiveCenterBloc({required this.remoteDataSource}) : super(LiveCenterInitial()) {
    on<WatchLiveMatch>(_onWatchMatch);
    on<LiveMatchUpdated>(_onMatchUpdated);
    on<LoadMatchEvents>(_onLoadEvents);
  }

  void _onWatchMatch(WatchLiveMatch event, Emitter<LiveCenterState> emit) {
    _matchSubscription?.cancel();
    emit(LiveCenterLoading());
    _matchSubscription = remoteDataSource.watchLiveMatch(event.matchId).listen(
      (state) => add(LiveMatchUpdated(state)),
      onError: (error) => emit(LiveCenterError(error.toString())),
    );
  }

  void _onMatchUpdated(LiveMatchUpdated event, Emitter<LiveCenterState> emit) {
    emit(LiveMatchStateLoaded(event.state));
  }

  Future<void> _onLoadEvents(LoadMatchEvents event, Emitter<LiveCenterState> emit) async {
    try {
      final events = await remoteDataSource.getMatchEvents(event.matchId);
      emit(LiveEventsLoaded(events));
    } catch (e) {
      emit(LiveCenterError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _matchSubscription?.cancel();
    return super.close();
  }
}
