import '../../domain/entities/ai_analysis.dart';

class AiAnalysisModel extends AiAnalysis {
  const AiAnalysisModel({
    required super.matchId,
    required super.homeWinProbability,
    required super.drawProbability,
    required super.awayWinProbability,
    required super.recommendedPrediction,
    required super.confidenceScore,
    required super.keyFactors,
    required super.reasoning,
    super.formAnalysis,
    super.injuries,
    super.suspensions,
    super.predictedLineupHome,
    super.predictedLineupAway,
    super.tacticalPreview,
    super.refereeTrends,
    super.weatherImpact,
    required super.generatedAt,
  });

  factory AiAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AiAnalysisModel(
      matchId: json['matchId'],
      homeWinProbability: json['homeWinProbability'].toDouble(),
      drawProbability: json['drawProbability'].toDouble(),
      awayWinProbability: json['awayWinProbability'].toDouble(),
      recommendedPrediction: json['recommendedPrediction'],
      confidenceScore: json['confidenceScore'].toDouble(),
      keyFactors: (json['keyFactors'] as List<dynamic>).cast<String>(),
      reasoning: json['reasoning'],
      formAnalysis: json['formAnalysis'] ?? {},
      injuries: (json['injuries'] as List<dynamic>?)?.cast<String>() ?? [],
      suspensions: (json['suspensions'] as List<dynamic>?)?.cast<String>() ?? [],
      predictedLineupHome: json['predictedLineupHome'],
      predictedLineupAway: json['predictedLineupAway'],
      tacticalPreview: json['tacticalPreview'],
      refereeTrends: json['refereeTrends'],
      weatherImpact: json['weatherImpact'],
      generatedAt: DateTime.parse(json['generatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'homeWinProbability': homeWinProbability,
      'drawProbability': drawProbability,
      'awayWinProbability': awayWinProbability,
      'recommendedPrediction': recommendedPrediction,
      'confidenceScore': confidenceScore,
      'keyFactors': keyFactors,
      'reasoning': reasoning,
      'formAnalysis': formAnalysis,
      'injuries': injuries,
      'suspensions': suspensions,
      'predictedLineupHome': predictedLineupHome,
      'predictedLineupAway': predictedLineupAway,
      'tacticalPreview': tacticalPreview,
      'refereeTrends': refereeTrends,
      'weatherImpact': weatherImpact,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}
