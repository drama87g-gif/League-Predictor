import 'package:equatable/equatable.dart';

class LiveEvent extends Equatable {
  final String id;
  final String matchId;
  final String type;
  final String? playerName;
  final String? team;
  final int minute;
  final String? description;
  final DateTime timestamp;

  const LiveEvent({
    required this.id,
    required this.matchId,
    required this.type,
    this.playerName,
    this.team,
    required this.minute,
    this.description,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, matchId, type, minute];
}

class LiveMatchState extends Equatable {
  final String matchId;
  final int homeScore;
  final int awayScore;
  final int minute;
  final String status;
  final int? homePossession;
  final int? awayPossession;
  final List<LiveEvent> events;
  final Map<String, dynamic> stats;

  const LiveMatchState({
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
    required this.minute,
    required this.status,
    this.homePossession,
    this.awayPossession,
    this.events = const [],
    this.stats = const {},
  });

  @override
  List<Object?> get props => [matchId, homeScore, awayScore, minute, status];
}
