import '../../domain/entities/league.dart';

class LeagueModel extends League {
  const LeagueModel({
    required super.id,
    required super.name,
    super.description,
    required super.ownerId,
    super.memberIds,
    super.scoringRules,
    required super.createdAt,
    super.isPublic,
    super.inviteCode,
    super.season,
    super.competitionFilter,
    super.imageUrl,
    super.maxMembers,
    super.members,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    return LeagueModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ownerId: json['ownerId'],
      memberIds: (json['memberIds'] as List<dynamic>?)?.cast<String>() ?? [],
      scoringRules: (json['scoringRules'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as int),
      ) ?? {},
      createdAt: DateTime.parse(json['createdAt']),
      isPublic: json['isPublic'] ?? false,
      inviteCode: json['inviteCode'],
      season: json['season'],
      competitionFilter: json['competitionFilter'],
      imageUrl: json['imageUrl'],
      maxMembers: json['maxMembers'] ?? 50,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => LeagueMemberModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'memberIds': memberIds,
      'scoringRules': scoringRules,
      'createdAt': createdAt.toIso8601String(),
      'isPublic': isPublic,
      'inviteCode': inviteCode,
      'season': season,
      'competitionFilter': competitionFilter,
      'imageUrl': imageUrl,
      'maxMembers': maxMembers,
    };
  }
}

class LeagueMemberModel extends LeagueMember {
  const LeagueMemberModel({
    required super.userId,
    required super.displayName,
    super.photoUrl,
    super.totalPoints,
    super.predictionsMade,
    super.predictionsCorrect,
    required super.joinedAt,
    super.isAdmin,
  });

  factory LeagueMemberModel.fromJson(Map<String, dynamic> json) {
    return LeagueMemberModel(
      userId: json['userId'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      totalPoints: json['totalPoints'] ?? 0,
      predictionsMade: json['predictionsMade'] ?? 0,
      predictionsCorrect: json['predictionsCorrect'] ?? 0,
      joinedAt: DateTime.parse(json['joinedAt']),
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}
