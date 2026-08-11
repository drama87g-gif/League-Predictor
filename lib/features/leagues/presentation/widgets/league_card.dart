import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/league.dart';

class LeagueCard extends StatelessWidget {
  final League league;
  final bool showJoinButton;

  const LeagueCard({super.key, required this.league, this.showJoinButton = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/league/${league.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A5F2A), Color(0xFF2E8B47)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emoji_events, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        league.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${league.memberIds.length} members',
                        style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (showJoinButton)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5F2A),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Join'),
                  ),
              ],
            ),
            if (league.description != null && league.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                league.description!,
                style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (league.isPublic)
                  _buildTag('Public', const Color(0xFF00B4D8))
                else
                  _buildTag('Private', const Color(0xFFF5A623)),
                const SizedBox(width: 8),
                if (league.competitionFilter != null)
                  _buildTag(league.competitionFilter!, const Color(0xFF8B95A5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
