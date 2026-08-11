import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/matches_bloc.dart';
import '../widgets/match_header.dart';
import '../widgets/prediction_summary.dart';
import '../widgets/team_stats_comparison.dart';
import '../widgets/recent_form.dart';

class MatchDetailPage extends StatefulWidget {
  final String matchId;
  const MatchDetailPage({super.key, required this.matchId});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<MatchesBloc>().add(LoadMatchDetails(widget.matchId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MatchesBloc, MatchesState>(
        builder: (context, state) {
          if (state is MatchDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MatchDetailsLoaded) {
            final match = state.match;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: MatchHeader(match: match),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Predictions'),
                      Tab(text: 'Stats'),
                      Tab(text: 'Lineups'),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(match),
                      _buildPredictionsTab(match),
                      _buildStatsTab(match),
                      _buildLineupsTab(match),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is MatchesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/match/${widget.matchId}/predict'),
        icon: const Icon(Icons.edit_note),
        label: const Text('Predict'),
      ),
    );
  }

  Widget _buildOverviewTab(dynamic match) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(match),
          const SizedBox(height: 16),
          RecentForm(teamName: match.homeTeam.name, form: ['W', 'D', 'W', 'L', 'W']),
          const SizedBox(height: 16),
          RecentForm(teamName: match.awayTeam.name, form: ['L', 'W', 'W', 'D', 'W']),
          const SizedBox(height: 16),
          _buildHeadToHead(),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPredictionsTab(dynamic match) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PredictionSummary(matchId: widget.matchId),
          const SizedBox(height: 16),
          _buildCommunityPredictions(),
        ],
      ),
    );
  }

  Widget _buildStatsTab(dynamic match) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: TeamStatsComparison(
        homeStats: match.homeTeam.stats,
        awayStats: match.awayTeam.stats,
      ),
    );
  }

  Widget _buildLineupsTab(dynamic match) {
    return const Center(child: Text('Lineups will be available 1 hour before kickoff'));
  }

  Widget _buildInfoCard(dynamic match) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.stadium, 'Venue', match.venue ?? 'TBA'),
            const Divider(),
            _buildInfoRow(Icons.person, 'Referee', match.referee ?? 'TBA'),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Date', DateFormat('EEEE, MMM dd, yyyy').format(match.matchDate)),
            const Divider(),
            _buildInfoRow(Icons.access_time, 'Time', DateFormat('HH:mm').format(match.matchDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF8B95A5)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Color(0xFF8B95A5))),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildHeadToHead() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Head to Head', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildH2HRow('Last 5 meetings', '3 - 1 - 1'),
            _buildH2HRow('Goals scored', '8 - 5'),
            _buildH2HRow('Clean sheets', '2 - 1'),
          ],
        ),
      ),
    );
  }

  Widget _buildH2HRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8B95A5))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCommunityPredictions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Community Predictions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPredictionBar('Home Win', 0.45, const Color(0xFF1A5F2A)),
            const SizedBox(height: 8),
            _buildPredictionBar('Draw', 0.25, const Color(0xFFF5A623)),
            const SizedBox(height: 8),
            _buildPredictionBar('Away Win', 0.30, const Color(0xFFDC052D)),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${(percentage * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: const Color(0xFF252B3B),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
