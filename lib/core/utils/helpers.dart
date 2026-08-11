import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Helpers {
  Helpers._();

  static const _uuid = Uuid();

  static String generateId() => _uuid.v4();

  static String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final buffer = StringBuffer();
    for (int i = 0; i < 6; i++) {
      buffer.write(chars[_uuid.v4().hashCode.abs() % chars.length]);
    }
    return buffer.toString();
  }

  static Color getTeamColor(String teamName) {
    final colors = [
      const Color(0xFFDC052D), // Red
      const Color(0xFF034694), // Blue
      const Color(0xFF6CABDD), // Light Blue
      const Color(0xFF00A650), // Green
      const Color(0xFFF5A623), // Gold
      const Color(0xFF7A003C), // Maroon
      const Color(0xFF1A1F2E), // Dark
      const Color(0xFF8B0000), // Dark Red
    ];
    return colors[teamName.hashCode.abs() % colors.length];
  }

  static String getCompetitionEmoji(String competition) {
    final map = {
      'Premier League': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
      'La Liga': '🇪🇸',
      'Serie A': '🇮🇹',
      'Bundesliga': '🇩🇪',
      'Ligue 1': '🇫🇷',
      'Champions League': '⭐',
      'Europa League': '🏆',
      'World Cup': '🌍',
      'Euro': '🇪🇺',
      'Copa America': '🌎',
      'FA Cup': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    };
    return map[competition] ?? '⚽';
  }

  static String formatPredictionType(String type) {
    final map = {
      'match_winner': 'Match Winner',
      'exact_score': 'Exact Score',
      'goal_difference': 'Goal Difference',
      'ht_score': 'Half-Time Score',
      'first_scorer': 'First Scorer',
      'btts': 'Both Teams To Score',
      'over_under': 'Over/Under',
      'clean_sheet': 'Clean Sheet',
      'penalty': 'Penalty',
      'red_card': 'Red Card',
      'yellow_cards': 'Yellow Cards',
      'corners': 'Corners',
      'player_of_match': 'Player of the Match',
      'tournament_winner': 'Tournament Winner',
      'golden_boot': 'Golden Boot',
    };
    return map[type] ?? type.titleCase;
  }

  static int calculatePoints(Map<String, dynamic> prediction, Map<String, dynamic> result) {
    int points = 0;

    if (prediction['type'] == 'match_winner') {
      final predicted = prediction['value'];
      final actual = result['winner'];
      if (predicted == actual) points = 5;
    } else if (prediction['type'] == 'exact_score') {
      final predicted = prediction['value'];
      final actual = '${result['home_score']}-${result['away_score']}';
      if (predicted == actual) points = 10;
    }

    return points;
  }

  static int calculateLevel(int xp) {
    const thresholds = [0, 500, 1200, 2500, 4500, 7000, 10000, 14000, 19000, 25000, 32000, 40000, 50000, 62000, 75000, 90000, 110000, 135000, 165000, 200000];
    for (int i = thresholds.length - 1; i >= 0; i--) {
      if (xp >= thresholds[i]) return i + 1;
    }
    return 1;
  }

  static int xpForNextLevel(int currentLevel) {
    const thresholds = [0, 500, 1200, 2500, 4500, 7000, 10000, 14000, 19000, 25000, 32000, 40000, 50000, 62000, 75000, 90000, 110000, 135000, 165000, 200000];
    if (currentLevel >= thresholds.length) return 999999;
    return thresholds[currentLevel];
  }
}
