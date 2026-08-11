class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Football Prediction Pro';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // API
  static const String baseUrl = 'https://api.football-data.org/v4';
  static const String apiKey = 'YOUR_API_KEY';
  static const int apiTimeout = 30000;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String matchesCollection = 'matches';
  static const String predictionsCollection = 'predictions';
  static const String leaguesCollection = 'leagues';
  static const String competitionsCollection = 'competitions';
  static const String notificationsCollection = 'notifications';
  static const String achievementsCollection = 'achievements';
  static const String transactionsCollection = 'transactions';

  // Cache
  static const String cacheBoxName = 'football_cache';
  static const int cacheExpiryHours = 24;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Prediction Rules
  static const int maxPredictionsPerMatch = 5;
  static const int predictionDeadlineMinutes = 15;
  static const int pointsExactScore = 10;
  static const int pointsCorrectWinner = 5;
  static const int pointsCorrectGoalDiff = 7;
  static const int pointsCorrectBtts = 3;
  static const int pointsCorrectOverUnder = 3;

  // Gamification
  static const int xpPerCorrectPrediction = 50;
  static const int xpPerExactScore = 200;
  static const int xpPerStreakBonus = 25;
  static const int coinsPerLevelUp = 100;
  static const List<int> levelThresholds = [
    0, 500, 1200, 2500, 4500, 7000, 10000, 14000, 19000, 25000,
    32000, 40000, 50000, 62000, 75000, 90000, 110000, 135000, 165000, 200000
  ];

  // Premium
  static const String premiumMonthlyId = 'premium_monthly';
  static const String premiumYearlyId = 'premium_yearly';
  static const String premiumLifetimeId = 'premium_lifetime';

  // Limits
  static const int maxFreeLeagues = 3;
  static const int maxFreePredictionsPerDay = 20;

  // Deep Links
  static const String scheme = 'footballprediction';
  static const String invitePath = '/invite';
  static const String matchPath = '/match';
}