import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ai_analysis.dart';

abstract class AiAnalysisRepository {
  Future<Either<Failure, AiAnalysis>> getAnalysis(String matchId);
  Future<Either<Failure, List<AiAnalysis>>> getHistoricalAccuracy(String matchId);
}
