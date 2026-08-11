import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/match.dart';

class MatchHeader extends StatelessWidget {
  final Match match;
  const MatchHeader({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F1419), Color(0xFF1A5F2A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                match.competition,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTeamInfo(match.homeTeam),
                  _buildScoreSection(),
                  _buildTeamInfo(match.awayTeam),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfo(Team team) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: team.crestUrl != null
              ? CachedNetworkImage(
                  imageUrl: team.crestUrl!,
                  width: 40,
                  height: 40,
                )
              : Center(
                  child: Text(
                    team.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            team.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection() {
    if (match.isLive || match.isFinished) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: match.isLive
                  ? const Color(0xFFE63946).withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${match.score?.home ?? 0} - ${match.score?.away ?? 0}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: match.isLive ? const Color(0xFFE63946) : Colors.white,
              ),
            ),
          ),
          if (match.isLive)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE63946),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${match.score?.duration ?? 0}'",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          match.matchDate.toString().substring(11, 16),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          match.matchDate.toString().substring(0, 10),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
