import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/live_center_bloc.dart';

class LiveMatchPage extends StatefulWidget {
  final String matchId;
  const LiveMatchPage({super.key, required this.matchId});

  @override
  State<LiveMatchPage> createState() => _LiveMatchPageState();
}

class _LiveMatchPageState extends State<LiveMatchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<LiveCenterBloc>().add(WatchLiveMatch(widget.matchId));
    context.read<LiveCenterBloc>().add(LoadMatchEvents(widget.matchId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LiveCenterBloc, LiveCenterState>(
        builder: (context, state) {
          if (state is LiveMatchStateLoaded) {
            final matchState = state.state;
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildLiveHeader(matchState),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Timeline'),
                      Tab(text: 'Stats'),
                      Tab(text: 'Momentum'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildTimelineTab(),
                  _buildStatsTab(matchState),
                  _buildMomentumTab(),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLiveHeader(dynamic matchState) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F1419), Color(0xFF1A5F2A)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE63946),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${matchState.minute}'",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamScore('Home', matchState.homeScore),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${matchState.homeScore} - ${matchState.awayScore}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                _buildTeamScore('Away', matchState.awayScore),
              ],
            ),
            const SizedBox(height: 12),
            if (matchState.homePossession != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: matchState.homePossession!,
                        child: Container(height: 4, color: const Color(0xFF1A5F2A)),
                      ),
                      Expanded(
                        flex: matchState.awayPossession ?? (100 - matchState.homePossession!),
                        child: Container(height: 4, color: const Color(0xFFDC052D)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamScore(String name, int score) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildTimelineTab() {
    return BlocBuilder<LiveCenterBloc, LiveCenterState>(
      builder: (context, state) {
        if (state is LiveEventsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
              final isHome = event.team == 'home';
              return TimelineTile(
                alignment: TimelineAlign.center,
                isFirst: index == 0,
                isLast: index == state.events.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 20,
                  color: _getEventColor(event.type),
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: _getEventIcon(event.type),
                  ),
                ),
                beforeLineStyle: const LineStyle(color: Color(0xFF252B3B)),
                afterLineStyle: const LineStyle(color: Color(0xFF252B3B)),
                startChild: isHome ? _buildEventCard(event) : null,
                endChild: !isHome ? _buildEventCard(event) : null,
              );
            },
          );
        }
        return const Center(child: Text('No events yet'));
      },
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${event.minute}'", style: const TextStyle(color: Color(0xFFF5A623), fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(event.playerName ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
          if (event.description != null)
            Text(event.description, style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 12)),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'GOAL': return const Color(0xFF2ECC71);
      case 'CARD': return const Color(0xFFF5A623);
      case 'RED_CARD': return const Color(0xFFE63946);
      case 'SUBSTITUTION': return const Color(0xFF00B4D8);
      default: return const Color(0xFF8B95A5);
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'GOAL': return Icons.sports_soccer;
      case 'CARD': return Icons.square;
      case 'RED_CARD': return Icons.square;
      case 'SUBSTITUTION': return Icons.swap_horiz;
      default: return Icons.circle;
    }
  }

  Widget _buildStatsTab(dynamic matchState) {
    final stats = matchState.stats as Map<String, dynamic>? ?? {};
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatComparison('Shots', stats['homeShots'] ?? 0, stats['awayShots'] ?? 0),
        _buildStatComparison('Shots on Target', stats['homeShotsOnTarget'] ?? 0, stats['awayShotsOnTarget'] ?? 0),
        _buildStatComparison('Corners', stats['homeCorners'] ?? 0, stats['awayCorners'] ?? 0),
        _buildStatComparison('Fouls', stats['homeFouls'] ?? 0, stats['awayFouls'] ?? 0),
        _buildStatComparison('Yellow Cards', stats['homeYellowCards'] ?? 0, stats['awayYellowCards'] ?? 0),
      ],
    );
  }

  Widget _buildStatComparison(String label, int home, int away) {
    final total = home + away;
    final homePercent = total > 0 ? home / total : 0.5;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$home', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(label, style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 12)),
              Text('$away', style: const TextStyle(fontWeight: FontWeight.w600)),
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

  Widget _buildMomentumTab() {
    return const Center(
      child: Text('Momentum graph coming soon'),
    );
  }
}
