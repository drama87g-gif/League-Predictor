import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/match.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/helpers.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final bool isLive;

  const MatchCard({super.key, required this.match, this.isLive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/match/${match.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2E),
          borderRadius: BorderRadius.circular(16),
          border: isLive
              ? Border.all(color: const Color(0xFFE63946).withOpacity(0.3), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTeamsRow(),
            const SizedBox(height: 12),
            if (match.isScheduled) _buildPredictionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          Helpers.getCompetitionEmoji(match.competition),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            match.competition,
            style: const TextStyle(
              color: Color(0xFF8B95A5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isLive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE63946).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE63946),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Color(0xFFE63946),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            match.matchDate.matchStatus,
            style: TextStyle(
              color: match.matchDate.isToday ? const Color(0xFF2E8B47) : const Color(0xFF5A6578),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildTeamsRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildTeamColumn(match.homeTeam, CrossAxisAlignment.end),
        ),
        Expanded(
          flex: 1,
          child: _buildScoreDisplay(),
        ),
        Expanded(
          flex: 2,
          child: _buildTeamColumn(match.awayTeam, CrossAxisAlignment.start),
        ),
      ],
    );
  }

  Widget _buildTeamColumn(Team team, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        _buildTeamCrest(team.crestUrl, team.name),
        const SizedBox(height: 8),
        Text(
          team.shortName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: alignment == CrossAxisAlignment.end ? TextAlign.right : TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTeamCrest(String? url, String fallbackName) {
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        width: 40,
        height: 40,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: const Color(0xFF252B3B),
          highlightColor: const Color(0xFF1A1F2E),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF252B3B),
              shape: BoxShape.circle,
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackCrest(fallbackName),
      );
    }
    return _buildFallbackCrest(fallbackName);
  }

  Widget _buildFallbackCrest(String name) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Helpers.getTeamColor(name).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.initials,
          style: TextStyle(
            color: Helpers.getTeamColor(name),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreDisplay() {
    if (match.isLive || match.isFinished) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: match.isLive
                  ? const Color(0xFFE63946).withOpacity(0.1)
                  : const Color(0xFF252B3B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${match.score?.home ?? 0} - ${match.score?.away ?? 0}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: match.isLive ? const Color(0xFFE63946) : Colors.white,
              ),
            ),
          ),
          if (match.isLive)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "${match.score?.duration ?? 0}'",
                style: const TextStyle(
                  color: Color(0xFFE63946),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          match.matchDate.formattedTime,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          match.matchDate.formattedDate,
          style: const TextStyle(
            color: Color(0xFF5A6578),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.go('/match/${match.id}/predict'),
        icon: const Icon(Icons.edit_note, size: 18),
        label: const Text('Make Prediction'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2E8B47),
          side: const BorderSide(color: Color(0xFF2E8B47)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
