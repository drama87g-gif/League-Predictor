import 'package:equatable/equatable.dart';

class UserStats extends Equatable {
  final int totalPredictions;
  final int correctPredictions;
  final int exactScores;
  final int totalPoints;
  final int currentStreak;
  final int bestStreak;
  final double accuracy;
  final Map<String, int> competitionPoints;
  final List<PredictionHistory> history;

  const UserStats({
    this.totalPredictions = 0,
    this.correctPredictions = 0,
    this.exactScores = 0,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.accuracy = 0.0,
    this.competitionPoints = const {},
    this.history = const [],
  });

  @override
  List<Object?> get props => [totalPredictions, correctPredictions, totalPoints, accuracy];
}

class PredictionHistory extends Equatable {
  final String matchId;
  final String matchTitle;
  final String predictionType;
  final String prediction;
  final String result;
  final int points;
  final DateTime date;
  final bool isCorrect;

  const PredictionHistory({
    required this.matchId,
    required this.matchTitle,
    required this.predictionType,
    required this.prediction,
    required this.result,
    required this.points,
    required this.date,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [matchId, points, isCorrect];
}
