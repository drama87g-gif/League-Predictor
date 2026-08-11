import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ai_analysis_model.dart';

abstract class AiAnalysisRemoteDataSource {
  Future<AiAnalysisModel> getAnalysis(String matchId);
}

class AiAnalysisRemoteDataSourceImpl implements AiAnalysisRemoteDataSource {
  final FirebaseFirestore firestore;
  AiAnalysisRemoteDataSourceImpl(this.firestore);

  @override
  Future<AiAnalysisModel> getAnalysis(String matchId) async {
    final doc = await firestore.collection('ai_analysis').doc(matchId).get();
    if (doc.exists) {
      return AiAnalysisModel.fromJson(doc.data()!);
    }
    // Generate mock analysis for demo
    return _generateMockAnalysis(matchId);
  }

  AiAnalysisModel _generateMockAnalysis(String matchId) {
    return AiAnalysisModel(
      matchId: matchId,
      homeWinProbability: 0.52,
      drawProbability: 0.24,
      awayWinProbability: 0.24,
      recommendedPrediction: 'Home Win',
      confidenceScore: 0.78,
      keyFactors: [
        'Home team has won 8 of last 10 home games',
        'Away team missing 3 key players through injury',
        'Home team scored 2+ goals in 7 of last 8 matches',
        'Historical H2H favors home team (W5 D2 L1)',
      ],
      reasoning: 'Based on current form, home advantage, and squad availability, the home team has a significant edge. The away team\'s defensive record on the road is concerning.',
      injuries: ['Away: Striker (knee)', 'Away: Midfielder (hamstring)', 'Home: Defender (suspension)'],
      suspensions: ['Home: #8 - Yellow card accumulation'],
      predictedLineupHome: '4-3-3 attacking formation expected',
      predictedLineupAway: '5-4-1 defensive setup likely',
      tacticalPreview: 'Home team will look to dominate possession and press high. Away team will sit deep and counter.',
      refereeTrends: 'Referee averages 4.2 yellow cards per game. Strict on tactical fouls.',
      weatherImpact: 'Clear skies, 18°C, light wind - ideal conditions',
      generatedAt: DateTime.now(),
    );
  }
}
