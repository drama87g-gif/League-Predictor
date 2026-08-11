import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ai_analysis.dart';
import '../repositories/ai_analysis_repository.dart';

class GetAiAnalysis implements UseCase<AiAnalysis, String> {
  final AiAnalysisRepository repository;
  GetAiAnalysis(this.repository);
  @override
  Future<Either<Failure, AiAnalysis>> call(String matchId) => repository.getAnalysis(matchId);
}
