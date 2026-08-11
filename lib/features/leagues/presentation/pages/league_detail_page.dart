import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/league_bloc.dart';

class LeagueDetailPage extends StatefulWidget {
  final String leagueId;
  const LeagueDetailPage({super.key, required this.leagueId});

  @override
  State<LeagueDetailPage> createState() => _LeagueDetailPageState();
}

class _LeagueDetailPageState extends State<LeagueDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<LeagueBloc>().add(LoadLeagueDetails(widget.leagueId));
    context.read<LeagueBloc>().add(LoadLeagueLeaderboard(widget.leagueId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LeagueBloc, LeagueState>(
        builder: (context, state) {
          if (state is LeagueDetailsLoaded) {
            final league = state.league;
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(league.name),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1A5F2A),
                            const Color(0xFF1A5F2A).withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emoji_events, size: 48, color: Color(0xFFF5A623)),
                            const SizedBox(height: 8),
                            Text(
                              '${league.memberIds.length}/${league.maxMembers} members',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Share.share('Join my league "${league.name}"! Code: ${league.inviteCode}');
                      },
                    ),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Leaderboard'),
                      Tab(text: 'Matches'),
                      Tab(text: 'Settings'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildLeaderboardTab(),
                  const Center(child: Text('Matches')),
                  _buildSettingsTab(league),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return BlocBuilder<LeagueBloc, LeagueState>(
      builder: (context, state) {
        if (state is LeagueLeaderboardLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.members.length,
            itemBuilder: (context, index) {
              final member = state.members[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: index < 3 ? const Color(0xFFF5A623).withOpacity(0.2) : const Color(0xFF252B3B),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: index < 3 ? const Color(0xFFF5A623) : const Color(0xFF8B95A5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: member.photoUrl != null ? NetworkImage(member.photoUrl!) : null,
                      child: member.photoUrl == null ? Text(member.displayName[0]) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            '${member.predictionsCorrect}/${member.predictionsMade} correct',
                            style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${member.totalPoints} pts',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF5A623)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildSettingsTab(dynamic league) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Invite Code', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                QrImageView(
                  data: league.inviteCode ?? '',
                  size: 150,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252B3B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    league.inviteCode ?? '',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
