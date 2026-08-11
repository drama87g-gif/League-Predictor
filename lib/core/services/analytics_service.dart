import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

  AnalyticsService(this._analytics, this._crashlytics);

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logPredictionMade(String matchId, String predictionType) async {
    await _analytics.logEvent(
      name: 'prediction_made',
      parameters: {'match_id': matchId, 'prediction_type': predictionType},
    );
  }

  Future<void> logLeagueJoined(String leagueId, String source) async {
    await _analytics.logEvent(
      name: 'league_joined',
      parameters: {'league_id': leagueId, 'source': source},
    );
  }

  Future<void> logPremiumPurchase(String productId, double price) async {
    await _analytics.logEvent(
      name: 'premium_purchase',
      parameters: {'product_id': productId, 'price': price},
    );
  }

  Future<void> logError(dynamic error, StackTrace stackTrace, {String? context}) async {
    await _crashlytics.recordError(error, stackTrace, reason: context);
  }

  Future<void> setUserProperties(String userId, {Map<String, String>? properties}) async {
    await _analytics.setUserId(id: userId);
    if (properties != null) {
      for (final entry in properties.entries) {
        await _analytics.setUserProperty(name: entry.key, value: entry.value);
      }
    }
  }
}