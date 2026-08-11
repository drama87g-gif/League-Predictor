part of 'ai_analysis_bloc.dart';

abstract class AiAnalysisState extends Equatable {
  const AiAnalysisState();
  @override
  List<Object?> get props => [];
}

class AiAnalysisInitial extends AiAnalysisState {}
class AiAnalysisLoading extends AiAnalysisState {}

class AiAnalysisLoaded extends AiAnalysisState {
  final AiAnalysis analysis;
  const AiAnalysisLoaded(this.analysis);
  @override
  List<Object?> get props => [analysis];
}

class AiAnalysisError extends AiAnalysisState {
  final String message;
  const AiAnalysisError(this.message);
  @override
  List<Object?> get props => [message];
}
