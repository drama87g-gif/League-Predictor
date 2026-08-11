import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/league.dart';

abstract class LeagueRepository {
  Future<Either<Failure, List<League>>> getPublicLeagues();
  Future<Either<Failure, List<League>>> getUserLeagues(String userId);
  Future<Either<Failure, League>> getLeagueDetails(String leagueId);
  Future<Either<Failure, League>> createLeague(League league);
  Future<Either<Failure, void>> joinLeague(String leagueId, String userId, {String? inviteCode});
  Future<Either<Failure, void>> leaveLeague(String leagueId, String userId);
  Future<Either<Failure, void>> updateLeague(League league);
  Future<Either<Failure, void>> deleteLeague(String leagueId);
  Future<Either<Failure, List<LeagueMember>>> getLeagueLeaderboard(String leagueId);
  Future<Either<Failure, String>> generateInviteCode(String leagueId);
}
