import '../../domain/entities/match.dart';

class MatchModel extends Match {
  const MatchModel({
    required super.id,
    required super.competition,
    required super.competitionId,
    required super.season,
    required super.matchDate,
    required super.status,
    super.stage,
    required super.homeTeam,
    required super.awayTeam,
    super.score,
    super.halfTimeScore,
    required super.availablePredictions,
    super.venue,
    super.referee,
    super.attendance,
    super.broadcasters,
    super.isFeatured,
    super.matchday,
    super.group,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'].toString(),
      competition: json['competition']?['name'] ?? 'Unknown',
      competitionId: json['competition']?['id']?.toString() ?? '',
      season: json['season']?.toString() ?? '',
      matchDate: DateTime.parse(json['utcDate'] ?? json['matchDate']),
      status: json['status'] ?? 'SCHEDULED',
      stage: json['stage'],
      homeTeam: TeamModel.fromJson(json['homeTeam'] ?? {}),
      awayTeam: TeamModel.fromJson(json['awayTeam'] ?? {}),
      score: json['score'] != null ? ScoreModel.fromJson(json['score']) : null,
      halfTimeScore: json['score']?['halfTime'] != null 
          ? ScoreModel.fromJson(json['score']['halfTime']) 
          : null,
      availablePredictions: _defaultPredictions(),
      venue: json['venue'],
      referee: json['referee'],
      attendance: json['attendance'],
      broadcasters: (json['broadcasters'] as List<dynamic>?)?.cast<String>(),
      isFeatured: json['isFeatured'] ?? false,
      matchday: json['matchday'],
      group: json['group'],
    );
  }

  factory MatchModel.fromFirestore(Map<String, dynamic> data, String id) {
    return MatchModel(
      id: id,
      competition: data['competition'] ?? '',
      competitionId: data['competitionId'] ?? '',
      season: data['season'] ?? '',
      matchDate: DateTime.parse(data['matchDate']),
      status: data['status'] ?? 'SCHEDULED',
      stage: data['stage'],
      homeTeam: TeamModel.fromJson(data['homeTeam'] ?? {}),
      awayTeam: TeamModel.fromJson(data['awayTeam'] ?? {}),
      score: data['score'] != null ? ScoreModel.fromJson(data['score']) : null,
      halfTimeScore: data['halfTimeScore'] != null ? ScoreModel.fromJson(data['halfTimeScore']) : null,
      availablePredictions: (data['availablePredictions'] as List<dynamic>?)
          ?.map((e) => PredictionTypeModel.fromJson(e))
          .toList() ?? _defaultPredictions(),
      venue: data['venue'],
      referee: data['referee'],
      attendance: data['attendance'],
      broadcasters: (data['broadcasters'] as List<dynamic>?)?.cast<String>(),
      isFeatured: data['isFeatured'] ?? false,
      matchday: data['matchday'],
      group: data['group'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'competition': competition,
      'competitionId': competitionId,
      'season': season,
      'matchDate': matchDate.toIso8601String(),
      'status': status,
      'stage': stage,
      'homeTeam': TeamModel.toJsonMap(homeTeam),
      'awayTeam': TeamModel.toJsonMap(awayTeam),
      'score': score != null ? ScoreModel.toJsonMap(score!) : null,
      'halfTimeScore': halfTimeScore != null ? ScoreModel.toJsonMap(halfTimeScore!) : null,
      'availablePredictions': availablePredictions.map((e) => PredictionTypeModel.toJsonMap(e)).toList(),
      'venue': venue,
      'referee': referee,
      'attendance': attendance,
      'broadcasters': broadcasters,
      'isFeatured': isFeatured,
      'matchday': matchday,
      'group': group,
    };
  }

  static List<PredictionType> _defaultPredictions() {
    return const [
      PredictionType(id: 'match_winner', name: 'Match Winner', description: 'Predict the winning team', points: 5),
      PredictionType(id: 'exact_score', name: 'Exact Score', description: 'Predict the exact final score', points: 10),
      PredictionType(id: 'goal_difference', name: 'Goal Difference', description: 'Predict the goal difference', points: 7),
      PredictionType(id: 'btts', name: 'BTTS', description: 'Both Teams To Score', points: 3),
      PredictionType(id: 'over_under', name: 'Over/Under 2.5', description: 'Total goals over or under 2.5', points: 3),
      PredictionType(id: 'clean_sheet', name: 'Clean Sheet', description: 'Will a team keep a clean sheet?', points: 4),
      PredictionType(id: 'first_scorer', name: 'First Scorer', description: 'Who scores first?', points: 8, requiresPremium: true),
      PredictionType(id: 'yellow_cards', name: 'Yellow Cards', description: 'Total yellow cards over/under', points: 4, requiresPremium: true),
      PredictionType(id: 'corners', name: 'Corners', description: 'Total corners over/under', points: 3, requiresPremium: true),
    ];
  }
}

class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.name,
    required super.shortName,
    super.crestUrl,
    super.country,
    super.founded,
    super.venue,
    super.coach,
    super.lineup,
    super.bench,
    super.stats,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id']?.toString() ?? json['name'] ?? '',
      name: json['name'] ?? 'Unknown',
      shortName: json['shortName'] ?? json['tla'] ?? json['name'] ?? 'UNK',
      crestUrl: json['crest'] ?? json['crestUrl'],
      country: json['area']?['name'] ?? json['country'],
      founded: json['founded']?.toString(),
      venue: json['venue'],
      coach: json['coach']?['name'],
      lineup: (json['lineup'] as List<dynamic>?)
          ?.map((e) => PlayerModel.fromJson(e))
          .toList(),
      bench: (json['bench'] as List<dynamic>?)
          ?.map((e) => PlayerModel.fromJson(e))
          .toList(),
      stats: json['stats'] != null ? TeamStatsModel.fromJson(json['stats']) : null,
    );
  }

  static Map<String, dynamic> toJsonMap(Team team) {
    return {
      'id': team.id,
      'name': team.name,
      'shortName': team.shortName,
      'crestUrl': team.crestUrl,
      'country': team.country,
    };
  }
}

class PlayerModel extends Player {
  const PlayerModel({
    required super.id,
    required super.name,
    super.position,
    super.shirtNumber,
    super.photoUrl,
    super.goals,
    super.assists,
    super.yellowCards,
    super.redCards,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      position: json['position'],
      shirtNumber: json['shirtNumber'],
      photoUrl: json['photoUrl'],
      goals: json['goals'],
      assists: json['assists'],
      yellowCards: json['yellowCards'],
      redCards: json['redCards'],
    );
  }
}

class ScoreModel extends Score {
  const ScoreModel({required super.home, required super.away, super.winner, super.duration});

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      home: json['home'] ?? json['homeTeam'] ?? 0,
      away: json['away'] ?? json['awayTeam'] ?? 0,
      winner: json['winner'],
      duration: json['duration'],
    );
  }

  static Map<String, dynamic> toJsonMap(Score score) {
    return {
      'home': score.home,
      'away': score.away,
      'winner': score.winner,
      'duration': score.duration,
    };
  }
}

class TeamStatsModel extends TeamStats {
  const TeamStatsModel({
    super.possession,
    super.shots,
    super.shotsOnTarget,
    super.corners,
    super.fouls,
    super.yellowCards,
    super.redCards,
    super.offsides,
  });

  factory TeamStatsModel.fromJson(Map<String, dynamic> json) {
    return TeamStatsModel(
      possession: json['possession'],
      shots: json['shots'],
      shotsOnTarget: json['shotsOnTarget'],
      corners: json['corners'],
      fouls: json['fouls'],
      yellowCards: json['yellowCards'],
      redCards: json['redCards'],
      offsides: json['offsides'],
    );
  }
}

class PredictionTypeModel extends PredictionType {
  const PredictionTypeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.points,
    super.requiresPremium,
    super.options,
  });

  factory PredictionTypeModel.fromJson(Map<String, dynamic> json) {
    return PredictionTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      points: json['points'],
      requiresPremium: json['requiresPremium'] ?? false,
      options: (json['options'] as List<dynamic>?)?.cast<String>(),
    );
  }

  static Map<String, dynamic> toJsonMap(PredictionType type) {
    return {
      'id': type.id,
      'name': type.name,
      'description': type.description,
      'points': type.points,
      'requiresPremium': type.requiresPremium,
      'options': type.options,
    };
  }
}

class PredictionModel extends Prediction {
  const PredictionModel({
    required super.id,
    required super.matchId,
    required super.userId,
    required super.predictionType,
    required super.value,
    required super.potentialPoints,
    super.earnedPoints,
    required super.createdAt,
    super.resolvedAt,
    super.isCorrect,
    super.leagueId,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'],
      matchId: json['matchId'],
      userId: json['userId'],
      predictionType: json['predictionType'],
      value: json['value'],
      potentialPoints: json['potentialPoints'],
      earnedPoints: json['earnedPoints'],
      createdAt: DateTime.parse(json['createdAt']),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      isCorrect: json['isCorrect'] ?? false,
      leagueId: json['leagueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'userId': userId,
      'predictionType': predictionType,
      'value': value,
      'potentialPoints': potentialPoints,
      'earnedPoints': earnedPoints,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'isCorrect': isCorrect,
      'leagueId': leagueId,
    };
  }
}
