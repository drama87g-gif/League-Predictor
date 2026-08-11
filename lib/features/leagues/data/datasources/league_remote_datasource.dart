import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/helpers.dart';
import '../models/league_model.dart';

abstract class LeagueRemoteDataSource {
  Future<List<LeagueModel>> getPublicLeagues();
  Future<List<LeagueModel>> getUserLeagues(String userId);
  Future<LeagueModel> getLeagueDetails(String leagueId);
  Future<LeagueModel> createLeague(LeagueModel league);
  Future<void> joinLeague(String leagueId, String userId, {String? inviteCode});
  Future<void> leaveLeague(String leagueId, String userId);
  Future<void> updateLeague(LeagueModel league);
  Future<void> deleteLeague(String leagueId);
  Future<List<LeagueMemberModel>> getLeagueLeaderboard(String leagueId);
  Future<String> generateInviteCode(String leagueId);
}

class LeagueRemoteDataSourceImpl implements LeagueRemoteDataSource {
  final FirebaseFirestore firestore;
  LeagueRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<LeagueModel>> getPublicLeagues() async {
    final snapshot = await firestore.collection(AppConstants.leaguesCollection)
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();
    return snapshot.docs.map((doc) => LeagueModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  @override
  Future<List<LeagueModel>> getUserLeagues(String userId) async {
    final snapshot = await firestore.collection(AppConstants.leaguesCollection)
        .where('memberIds', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => LeagueModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  @override
  Future<LeagueModel> getLeagueDetails(String leagueId) async {
    final doc = await firestore.collection(AppConstants.leaguesCollection).doc(leagueId).get();
    if (!doc.exists) throw Exception('League not found');
    return LeagueModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  @override
  Future<LeagueModel> createLeague(LeagueModel league) async {
    final docRef = firestore.collection(AppConstants.leaguesCollection).doc();
    final code = Helpers.generateInviteCode();
    final newLeague = LeagueModel(
      id: docRef.id,
      name: league.name,
      description: league.description,
      ownerId: league.ownerId,
      memberIds: [league.ownerId],
      scoringRules: league.scoringRules,
      createdAt: DateTime.now(),
      isPublic: league.isPublic,
      inviteCode: code,
      season: league.season,
      competitionFilter: league.competitionFilter,
      imageUrl: league.imageUrl,
      maxMembers: league.maxMembers,
    );
    await docRef.set(newLeague.toJson());
    return newLeague;
  }

  @override
  Future<void> joinLeague(String leagueId, String userId, {String? inviteCode}) async {
    final docRef = firestore.collection(AppConstants.leaguesCollection).doc(leagueId);
    final doc = await docRef.get();
    if (!doc.exists) throw Exception('League not found');

    final league = LeagueModel.fromJson({...doc.data()!, 'id': doc.id});
    if (league.isFull) throw Exception('League is full');
    if (!league.isPublic && league.inviteCode != inviteCode) throw Exception('Invalid invite code');
    if (league.memberIds.contains(userId)) throw Exception('Already a member');

    await docRef.update({
      'memberIds': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<void> leaveLeague(String leagueId, String userId) async {
    final docRef = firestore.collection(AppConstants.leaguesCollection).doc(leagueId);
    await docRef.update({
      'memberIds': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<void> updateLeague(LeagueModel league) async {
    await firestore.collection(AppConstants.leaguesCollection).doc(league.id).update(league.toJson());
  }

  @override
  Future<void> deleteLeague(String leagueId) async {
    await firestore.collection(AppConstants.leaguesCollection).doc(leagueId).delete();
  }

  @override
  Future<List<LeagueMemberModel>> getLeagueLeaderboard(String leagueId) async {
    final snapshot = await firestore.collection(AppConstants.leaguesCollection)
        .doc(leagueId)
        .collection('members')
        .orderBy('totalPoints', descending: true)
        .get();
    return snapshot.docs.map((doc) => LeagueMemberModel.fromJson(doc.data())).toList();
  }

  @override
  Future<String> generateInviteCode(String leagueId) async {
    final code = Helpers.generateInviteCode();
    await firestore.collection(AppConstants.leaguesCollection).doc(leagueId).update({'inviteCode': code});
    return code;
  }
}
