import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/league.dart';
import '../repositories/league_repository.dart';

class GetPublicLeagues implements UseCase<List<League>, NoParams> {
  final LeagueRepository repository;
  GetPublicLeagues(this.repository);
  @override
  Future<Either<Failure, List<League>>> call(NoParams params) => repository.getPublicLeagues();
}

class GetUserLeagues implements UseCase<List<League>, String> {
  final LeagueRepository repository;
  GetUserLeagues(this.repository);
  @override
  Future<Either<Failure, List<League>>> call(String userId) => repository.getUserLeagues(userId);
}

class GetLeagueDetails implements UseCase<League, String> {
  final LeagueRepository repository;
  GetLeagueDetails(this.repository);
  @override
  Future<Either<Failure, League>> call(String leagueId) => repository.getLeagueDetails(leagueId);
}

class CreateLeague implements UseCase<League, League> {
  final LeagueRepository repository;
  CreateLeague(this.repository);
  @override
  Future<Either<Failure, League>> call(League league) => repository.createLeague(league);
}

class JoinLeague implements UseCase<void, JoinLeagueParams> {
  final LeagueRepository repository;
  JoinLeague(this.repository);
  @override
  Future<Either<Failure, void>> call(JoinLeagueParams params) => 
      repository.joinLeague(params.leagueId, params.userId, inviteCode: params.inviteCode);
}

class GetLeagueLeaderboard implements UseCase<List<LeagueMember>, String> {
  final LeagueRepository repository;
  GetLeagueLeaderboard(this.repository);
  @override
  Future<Either<Failure, List<LeagueMember>>> call(String leagueId) => repository.getLeagueLeaderboard(leagueId);
}

class JoinLeagueParams {
  final String leagueId;
  final String userId;
  final String? inviteCode;
  JoinLeagueParams({required this.leagueId, required this.userId, this.inviteCode});
}
