import 'package:equatable/equatable.dart';

class AiAnalysis extends Equatable {
  final String matchId;
  final double homeWinProbability;
  final double drawProbability;
  final double awayWinProbability;
  final String recommendedPrediction;
  final double confidenceScore;
  final List<String> keyFactors;
  final String reasoning;
  final Map<String, dynamic> formAnalysis;
  final List<String> injuries;
  final List<String> suspensions;
  final String? predictedLineupHome;
  final String? predictedLineupAway;
  final String? tacticalPreview;
  final String? refereeTrends;
  final String? weatherImpact;
  final DateTime generatedAt;

  const AiAnalysis({
    required this.matchId,
    required this.homeWinProbability,
    required this.drawProbability,
    required this.awayWinProbability,
    required this.recommendedPrediction,
    required this.confidenceScore,
    required this.keyFactors,
    required this.reasoning,
    this.formAnalysis = const {},
    this.injuries = const [],
    this.suspensions = const [],
    this.predictedLineupHome,
    this.predictedLineupAway,
    this.tacticalPreview,
    this.refereeTrends,
    this.weatherImpact,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [matchId, confidenceScore, recommendedPrediction];
}
