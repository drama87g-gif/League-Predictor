import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/ai_analysis.dart';
import '../../domain/usecases/ai_usecases.dart';

part 'ai_event.dart';
part 'ai_state.dart';

class AiAnalysisBloc extends Bloc<AiAnalysisEvent, AiAnalysisState> {
  final GetAiAnalysis getAiAnalysis;

  AiAnalysisBloc({required this.getAiAnalysis}) : super(AiAnalysisInitial()) {
    on<LoadAiAnalysis>(_onLoadAnalysis);
  }

  Future<void> _onLoadAnalysis(LoadAiAnalysis event, Emitter<AiAnalysisState> emit) async {
    emit(AiAnalysisLoading());
    final result = await getAiAnalysis(event.matchId);
    result.fold(
      (failure) => emit(AiAnalysisError(failure.message)),
      (analysis) => emit(AiAnalysisLoaded(analysis)),
    );
  }
}
