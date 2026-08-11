import '../../domain/entities/live_event.dart';

class LiveEventModel extends LiveEvent {
  const LiveEventModel({
    required super.id,
    required super.matchId,
    required super.type,
    super.playerName,
    super.team,
    required super.minute,
    super.description,
    required super.timestamp,
  });

  factory LiveEventModel.fromJson(Map<String, dynamic> json) {
    return LiveEventModel(
      id: json['id'],
      matchId: json['matchId'],
      type: json['type'],
      playerName: json['playerName'],
      team: json['team'],
      minute: json['minute'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class LiveMatchStateModel extends LiveMatchState {
  const LiveMatchStateModel({
    required super.matchId,
    required super.homeScore,
    required super.awayScore,
    required super.minute,
    required super.status,
    super.homePossession,
    super.awayPossession,
    super.events,
    super.stats,
  });

  factory LiveMatchStateModel.fromJson(Map<String, dynamic> json) {
    return LiveMatchStateModel(
      matchId: json['matchId'],
      homeScore: json['homeScore'] ?? 0,
      awayScore: json['awayScore'] ?? 0,
      minute: json['minute'] ?? 0,
      status: json['status'] ?? 'LIVE',
      homePossession: json['homePossession'],
      awayPossession: json['awayPossession'],
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => LiveEventModel.fromJson(e))
          .toList() ?? [],
      stats: json['stats'] ?? {},
    );
  }
}
