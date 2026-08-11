import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ai_analysis.dart';
import '../../domain/repositories/ai_analysis_repository.dart';
import '../datasources/ai_analysis_remote_datasource.dart';

class AiAnalysisRepositoryImpl implements AiAnalysisRepository {
  final AiAnalysisRemoteDataSource remoteDataSource;
  AiAnalysisRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AiAnalysis>> getAnalysis(String matchId) async {
    try {
      final analysis = await remoteDataSource.getAnalysis(matchId);
      return Right(analysis);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AiAnalysis>>> getHistoricalAccuracy(String matchId) async {
    return const Right([]);
  }
}
