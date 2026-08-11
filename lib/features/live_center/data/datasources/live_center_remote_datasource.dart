import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/live_event_model.dart';

abstract class LiveCenterRemoteDataSource {
  Stream<LiveMatchStateModel> watchLiveMatch(String matchId);
  Future<List<LiveEventModel>> getMatchEvents(String matchId);
}

class LiveCenterRemoteDataSourceImpl implements LiveCenterRemoteDataSource {
  final FirebaseFirestore firestore;
  LiveCenterRemoteDataSourceImpl(this.firestore);

  @override
  Stream<LiveMatchStateModel> watchLiveMatch(String matchId) {
    return firestore.collection('live_matches').doc(matchId).snapshots().map((doc) {
      if (doc.exists) {
        return LiveMatchStateModel.fromJson(doc.data()!);
      }
      return LiveMatchStateModel(
        matchId: matchId,
        homeScore: 0,
        awayScore: 0,
        minute: 0,
        status: 'LIVE',
      );
    });
  }

  @override
  Future<List<LiveEventModel>> getMatchEvents(String matchId) async {
    final snapshot = await firestore.collection('live_matches')
        .doc(matchId)
        .collection('events')
        .orderBy('minute')
        .get();
    return snapshot.docs.map((doc) => LiveEventModel.fromJson(doc.data())).toList();
  }
}
