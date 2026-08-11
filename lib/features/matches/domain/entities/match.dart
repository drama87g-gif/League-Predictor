import 'package:equatable/equatable.dart';

class Match extends Equatable {
  final String id;
  final String competition;
  final String competitionId;
  final String season;
  final DateTime matchDate;
  final String status;
  final String? stage;
  final Team homeTeam;
  final Team awayTeam;
  final Score? score;
  final Score? halfTimeScore;
  final List<PredictionType> availablePredictions;
  final String? venue;
  final String? referee;
  final int? attendance;
  final List<String>? broadcasters;
  final bool isFeatured;
  final int? matchday;
  final String? group;

  const Match({
    required this.id,
    required this.competition,
    required this.competitionId,
    required this.season,
    required this.matchDate,
    required this.status,
    this.stage,
    required this.homeTeam,
    required this.awayTeam,
    this.score,
    this.halfTimeScore,
    required this.availablePredictions,
    this.venue,
    this.referee,
    this.attendance,
    this.broadcasters,
    this.isFeatured = false,
    this.matchday,
    this.group,
  });

  bool get isLive => status == 'LIVE' || status == 'IN_PLAY';
  bool get isFinished => status == 'FINISHED';
  bool get isScheduled => status == 'SCHEDULED' || status == 'TIMED';
  bool get isPostponed => status == 'POSTPONED';

  @override
  List<Object?> get props => [id, competition, homeTeam, awayTeam, score, status];
}

class Team extends Equatable {
  final String id;
  final String name;
  final String shortName;
  final String? crestUrl;
  final String? country;
  final String? founded;
  final String? venue;
  final String? coach;
  final List<Player>? lineup;
  final List<Player>? bench;
  final TeamStats? stats;

  const Team({
    required this.id,
    required this.name,
    required this.shortName,
    this.crestUrl,
    this.country,
    this.founded,
    this.venue,
    this.coach,
    this.lineup,
    this.bench,
    this.stats,
  });

  @override
  List<Object?> get props => [id, name, shortName];
}

class Player extends Equatable {
  final String id;
  final String name;
  final String? position;
  final int? shirtNumber;
  final String? photoUrl;
  final int? goals;
  final int? assists;
  final int? yellowCards;
  final int? redCards;

  const Player({
    required this.id,
    required this.name,
    this.position,
    this.shirtNumber,
    this.photoUrl,
    this.goals,
    this.assists,
    this.yellowCards,
    this.redCards,
  });

  @override
  List<Object?> get props => [id, name, position];
}

class Score extends Equatable {
  final int home;
  final int away;
  final String? winner;
  final int? duration;

  const Score({required this.home, required this.away, this.winner, this.duration});

  @override
  List<Object?> get props => [home, away, winner];
}

class TeamStats extends Equatable {
  final int? possession;
  final int? shots;
  final int? shotsOnTarget;
  final int? corners;
  final int? fouls;
  final int? yellowCards;
  final int? redCards;
  final int? offsides;

  const TeamStats({
    this.possession,
    this.shots,
    this.shotsOnTarget,
    this.corners,
    this.fouls,
    this.yellowCards,
    this.redCards,
    this.offsides,
  });

  @override
  List<Object?> get props => [possession, shots, shotsOnTarget, corners];
}

class PredictionType extends Equatable {
  final String id;
  final String name;
  final String description;
  final int points;
  final bool requiresPremium;
  final List<String>? options;

  const PredictionType({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    this.requiresPremium = false,
    this.options,
  });

  @override
  List<Object?> get props => [id, name, points];
}

class Prediction extends Equatable {
  final String id;
  final String matchId;
  final String userId;
  final String predictionType;
  final String value;
  final int potentialPoints;
  final int? earnedPoints;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final bool isCorrect;
  final String? leagueId;

  const Prediction({
    required this.id,
    required this.matchId,
    required this.userId,
    required this.predictionType,
    required this.value,
    required this.potentialPoints,
    this.earnedPoints,
    required this.createdAt,
    this.resolvedAt,
    this.isCorrect = false,
    this.leagueId,
  });

  @override
  List<Object?> get props => [id, matchId, userId, predictionType, value, isCorrect];
}
