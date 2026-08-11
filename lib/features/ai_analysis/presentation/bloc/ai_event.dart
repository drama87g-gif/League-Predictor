part of 'ai_analysis_bloc.dart';

abstract class AiAnalysisEvent extends Equatable {
  const AiAnalysisEvent();
  @override
  List<Object?> get props => [];
}

class LoadAiAnalysis extends AiAnalysisEvent {
  final String matchId;
  const LoadAiAnalysis(this.matchId);
  @override
  List<Object?> get props => [matchId];
}
