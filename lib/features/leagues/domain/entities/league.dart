import 'package:equatable/equatable.dart';

class League extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final List<String> memberIds;
  final Map<String, int> scoringRules;
  final DateTime createdAt;
  final bool isPublic;
  final String? inviteCode;
  final String? season;
  final String? competitionFilter;
  final String? imageUrl;
  final int maxMembers;
  final List<LeagueMember> members;

  const League({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    this.memberIds = const [],
    this.scoringRules = const {},
    required this.createdAt,
    this.isPublic = false,
    this.inviteCode,
    this.season,
    this.competitionFilter,
    this.imageUrl,
    this.maxMembers = 50,
    this.members = const [],
  });

  bool get isFull => memberIds.length >= maxMembers;
  bool get isOwner => false; // Check against current user

  @override
  List<Object?> get props => [id, name, ownerId, memberIds];
}

class LeagueMember extends Equatable {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final int totalPoints;
  final int predictionsMade;
  final int predictionsCorrect;
  final DateTime joinedAt;
  final bool isAdmin;

  const LeagueMember({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    this.totalPoints = 0,
    this.predictionsMade = 0,
    this.predictionsCorrect = 0,
    required this.joinedAt,
    this.isAdmin = false,
  });

  double get accuracy => predictionsMade > 0 ? (predictionsCorrect / predictionsMade) * 100 : 0;

  @override
  List<Object?> get props => [userId, displayName, totalPoints];
}
