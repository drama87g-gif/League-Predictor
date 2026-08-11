import 'package:flutter/material.dart';
import '../../domain/entities/match.dart';

class TeamStatsComparison extends StatelessWidget {
  final TeamStats? homeStats;
  final TeamStats? awayStats;

  const TeamStatsComparison({super.key, this.homeStats, this.awayStats});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData('Possession', homeStats?.possession ?? 50, awayStats?.possession ?? 50, '%'),
      _StatData('Shots', homeStats?.shots ?? 0, awayStats?.shots ?? 0, ''),
      _StatData('Shots on Target', homeStats?.shotsOnTarget ?? 0, awayStats?.shotsOnTarget ?? 0, ''),
      _StatData('Corners', homeStats?.corners ?? 0, awayStats?.corners ?? 0, ''),
      _StatData('Fouls', homeStats?.fouls ?? 0, awayStats?.fouls ?? 0, ''),
      _StatData('Yellow Cards', homeStats?.yellowCards ?? 0, awayStats?.yellowCards ?? 0, ''),
    ];

    return Column(
      children: stats.map((stat) => _buildStatRow(stat)).toList(),
    );
  }

  Widget _buildStatRow(_StatData stat) {
    final total = stat.homeValue + stat.awayValue;
    final homePercent = total > 0 ? stat.homeValue / total : 0.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${stat.homeValue}${stat.unit}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                stat.label,
                style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 12),
              ),
              Text(
                '${stat.awayValue}${stat.unit}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: (homePercent * 100).toInt(),
                  child: Container(height: 6, color: const Color(0xFF1A5F2A)),
                ),
                Expanded(
                  flex: ((1 - homePercent) * 100).toInt(),
                  child: Container(height: 6, color: const Color(0xFFDC052D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  final String label;
  final num homeValue;
  final num awayValue;
  final String unit;
  _StatData(this.label, this.homeValue, this.awayValue, this.unit);
}
