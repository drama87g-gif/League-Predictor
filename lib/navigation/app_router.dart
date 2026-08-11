import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/matches/presentation/pages/match_detail_page.dart';
import '../features/matches/presentation/pages/prediction_page.dart';
import '../features/leagues/presentation/pages/league_detail_page.dart';
import '../features/leagues/presentation/pages/create_league_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../features/ai_analysis/presentation/pages/ai_analysis_page.dart';
import '../features/live_center/presentation/pages/live_match_page.dart';
import '../features/gamification/presentation/pages/achievements_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => HomePage(child: child),
        routes: [
          GoRoute(
            path: '/matches',
            builder: (context, state) => const MatchesTab(),
          ),
          GoRoute(
            path: '/leagues',
            builder: (context, state) => const LeaguesTab(),
          ),
          GoRoute(
            path: '/leaderboard',
            builder: (context, state) => const LeaderboardTab(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileTab(),
          ),
        ],
      ),
      GoRoute(
        path: '/match/:id',
        builder: (context, state) => MatchDetailPage(
          matchId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/match/:id/predict',
        builder: (context, state) => PredictionPage(
          matchId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/league/:id',
        builder: (context, state) => LeagueDetailPage(
          leagueId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/league/create',
        builder: (context, state) => const CreateLeaguePage(),
      ),
      GoRoute(
        path: '/ai-analysis/:matchId',
        builder: (context, state) => AiAnalysisPage(
          matchId: state.pathParameters['matchId']!,
        ),
      ),
      GoRoute(
        path: '/live/:matchId',
        builder: (context, state) => LiveMatchPage(
          matchId: state.pathParameters['matchId']!,
        ),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsPage(),
      ),
    ],
  );
}
