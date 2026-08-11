import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/services/analytics_service.dart';
import '../core/services/notification_service.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/auth_usecases.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/ai_analysis/data/datasources/ai_analysis_remote_datasource.dart';
import '../features/ai_analysis/data/repositories/ai_analysis_repository_impl.dart';
import '../features/ai_analysis/domain/repositories/ai_analysis_repository.dart';
import '../features/ai_analysis/domain/usecases/ai_usecases.dart';
import '../features/ai_analysis/presentation/bloc/ai_analysis_bloc.dart';
import '../features/leagues/data/datasources/league_remote_datasource.dart';
import '../features/leagues/data/repositories/league_repository_impl.dart';
import '../features/leagues/domain/repositories/league_repository.dart';
import '../features/leagues/domain/usecases/league_usecases.dart';
import '../features/leagues/presentation/bloc/league_bloc.dart';
import '../features/live_center/data/datasources/live_center_remote_datasource.dart';
import '../features/live_center/presentation/bloc/live_center_bloc.dart';
import '../features/matches/data/datasources/match_remote_datasource.dart';
import '../features/matches/data/repositories/match_repository_impl.dart';
import '../features/matches/domain/repositories/match_repository.dart';
import '../features/matches/domain/usecases/match_usecases.dart';
import '../features/matches/presentation/bloc/matches_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<AuthBloc>()) return;

  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  getIt.registerLazySingleton<FirebaseCrashlytics>(() => FirebaseCrashlytics.instance);
  getIt.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => FlutterLocalNotificationsPlugin());

  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService(getIt(), getIt()));
  getIt.registerLazySingleton<NotificationService>(() => NotificationService(getIt(), getIt()));

  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton(() => SignInWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithGoogle(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithApple(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOut(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => UpdateProfile(getIt<AuthRepository>()));
  getIt.registerFactory(() => AuthBloc(
    signInWithEmail: getIt(), signUpWithEmail: getIt(), signInWithGoogle: getIt(),
    signInWithApple: getIt(), signOut: getIt(), getCurrentUser: getIt(), updateProfile: getIt(),
  ));

  getIt.registerLazySingleton<MatchRemoteDataSource>(() => MatchRemoteDataSourceImpl(apiClient: getIt(), firestore: getIt()));
  getIt.registerLazySingleton<MatchRepository>(() => MatchRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton(() => GetMatches(getIt<MatchRepository>()));
  getIt.registerLazySingleton(() => GetLiveMatches(getIt<MatchRepository>()));
  getIt.registerLazySingleton(() => GetFeaturedMatches(getIt<MatchRepository>()));
  getIt.registerLazySingleton(() => GetMatchDetails(getIt<MatchRepository>()));
  getIt.registerLazySingleton(() => MakePrediction(getIt<MatchRepository>()));
  getIt.registerLazySingleton(() => GetUserPredictions(getIt<MatchRepository>()));
  getIt.registerLazySingleton(() => WatchLiveMatch(getIt<MatchRepository>()));
  getIt.registerFactory(() => MatchesBloc(
    getMatches: getIt(), getLiveMatches: getIt(), getFeaturedMatches: getIt(), getMatchDetails: getIt(),
    makePrediction: getIt(), getUserPredictions: getIt(), watchLiveMatch: getIt(),
  ));

  getIt.registerLazySingleton<LeagueRemoteDataSource>(() => LeagueRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<LeagueRepository>(() => LeagueRepositoryImpl(remoteDataSource: getIt(), networkInfo: getIt()));
  getIt.registerLazySingleton(() => GetPublicLeagues(getIt<LeagueRepository>()));
  getIt.registerLazySingleton(() => GetUserLeagues(getIt<LeagueRepository>()));
  getIt.registerLazySingleton(() => GetLeagueDetails(getIt<LeagueRepository>()));
  getIt.registerLazySingleton(() => CreateLeague(getIt<LeagueRepository>()));
  getIt.registerLazySingleton(() => JoinLeague(getIt<LeagueRepository>()));
  getIt.registerLazySingleton(() => GetLeagueLeaderboard(getIt<LeagueRepository>()));
  getIt.registerFactory(() => LeagueBloc(
    getPublicLeagues: getIt(), getUserLeagues: getIt(), getLeagueDetails: getIt(),
    createLeague: getIt(), joinLeague: getIt(), getLeagueLeaderboard: getIt(),
  ));

  getIt.registerLazySingleton<LiveCenterRemoteDataSource>(() => LiveCenterRemoteDataSourceImpl(getIt()));
  getIt.registerFactory(() => LiveCenterBloc(remoteDataSource: getIt()));

  getIt.registerLazySingleton<AiAnalysisRemoteDataSource>(() => AiAnalysisRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<AiAnalysisRepository>(() => AiAnalysisRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => GetAiAnalysis(getIt<AiAnalysisRepository>()));
  getIt.registerFactory(() => AiAnalysisBloc(getAiAnalysis: getIt()));
}
