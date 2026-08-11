import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/match_model.dart';

abstract class MatchRemoteDataSource {
  Future<List<MatchModel>> getMatches({String? competition, String? dateFrom, String? dateTo, String? status});
  Future<MatchModel> getMatchDetails(String matchId);
  Future<List<MatchModel>> getLiveMatches();
  Future<List<MatchModel>> getFeaturedMatches();
  Future<List<MatchModel>> getMatchesByCompetition(String competitionId);
  Future<List<MatchModel>> getMatchesByDate(DateTime date);

  Future<List<PredictionModel>> getUserPredictions(String userId, {String? matchId});
  Future<PredictionModel> makePrediction(PredictionModel prediction);
  Future<void> cancelPrediction(String predictionId);
  Future<List<PredictionModel>> getMatchPredictions(String matchId);

  Stream<MatchModel> watchLiveMatch(String matchId);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  final ApiClient apiClient;
  final FirebaseFirestore firestore;

  MatchRemoteDataSourceImpl({required this.apiClient, required this.firestore});

  @override
  Future<List<MatchModel>> getMatches({String? competition, String? dateFrom, String? dateTo, String? status}) async {
    final queryParams = <String, dynamic>{};
    if (competition != null) queryParams['competitions'] = competition;
    if (dateFrom != null) queryParams['dateFrom'] = dateFrom;
    if (dateTo != null) queryParams['dateTo'] = dateTo;
    if (status != null) queryParams['status'] = status;

    try {
      final response = await apiClient.get('/matches', queryParameters: queryParams);
      final matches = (response.data['matches'] as List<dynamic>)
          .map((json) => MatchModel.fromJson(json))
          .toList();
      return matches;
    } catch (e) {
      // Fallback to Firestore
      var query = firestore.collection(AppConstants.matchesCollection).orderBy('matchDate');
      if (competition != null) query = query.where('competitionId', isEqualTo: competition);
      if (status != null) query = query.where('status', isEqualTo: status);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => MatchModel.fromFirestore(doc.data(), doc.id)).toList();
    }
  }

  @override
  Future<MatchModel> getMatchDetails(String matchId) async {
    try {
      final response = await apiClient.get('/matches/$matchId');
      return MatchModel.fromJson(response.data);
    } catch (e) {
      final doc = await firestore.collection(AppConstants.matchesCollection).doc(matchId).get();
      if (doc.exists) {
        return MatchModel.fromFirestore(doc.data()!, doc.id);
      }
      throw Exception('Match not found');
    }
  }

  @override
  Future<List<MatchModel>> getLiveMatches() async {
    final query = firestore.collection(AppConstants.matchesCollection)
        .where('status', whereIn: ['LIVE', 'IN_PLAY'])
        .orderBy('matchDate');
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => MatchModel.fromFirestore(doc.data(), doc.id)).toList();
  }

  @override
  Future<List<MatchModel>> getFeaturedMatches() async {
    final query = firestore.collection(AppConstants.matchesCollection)
        .where('isFeatured', isEqualTo: true)
        .orderBy('matchDate')
        .limit(10);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => MatchModel.fromFirestore(doc.data(), doc.id)).toList();
  }

  @override
  Future<List<MatchModel>> getMatchesByCompetition(String competitionId) async {
    return getMatches(competition: competitionId);
  }

  @override
  Future<List<MatchModel>> getMatchesByDate(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    return getMatches(dateFrom: dateStr, dateTo: dateStr);
  }

  @override
  Future<List<PredictionModel>> getUserPredictions(String userId, {String? matchId}) async {
    var query = firestore.collection(AppConstants.predictionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (matchId != null) {
      query = query.where('matchId', isEqualTo: matchId);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => PredictionModel.fromJson(doc.data())).toList();
  }

  @override
  Future<PredictionModel> makePrediction(PredictionModel prediction) async {
    await firestore.collection(AppConstants.predictionsCollection)
        .doc(prediction.id)
        .set(prediction.toJson());
    return prediction;
  }

  @override
  Future<void> cancelPrediction(String predictionId) async {
    await firestore.collection(AppConstants.predictionsCollection).doc(predictionId).delete();
  }

  @override
  Future<List<PredictionModel>> getMatchPredictions(String matchId) async {
    final snapshot = await firestore.collection(AppConstants.predictionsCollection)
        .where('matchId', isEqualTo: matchId)
        .get();
    return snapshot.docs.map((doc) => PredictionModel.fromJson(doc.data())).toList();
  }

  @override
  Stream<MatchModel> watchLiveMatch(String matchId) {
    return firestore.collection(AppConstants.matchesCollection)
        .doc(matchId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return MatchModel.fromFirestore(snapshot.data()!, snapshot.id);
          }
          throw Exception('Match not found');
        });
  }
}
