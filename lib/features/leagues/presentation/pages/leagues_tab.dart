import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../bloc/league_bloc.dart';
import '../widgets/league_card.dart';

class LeaguesTab extends StatefulWidget {
  const LeaguesTab({super.key});

  @override
  State<LeaguesTab> createState() => _LeaguesTabState();
}

class _LeaguesTabState extends State<LeaguesTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<LeagueBloc>().add(LoadPublicLeagues());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leagues'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'My Leagues'), Tab(text: 'Discover')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyLeaguesTab(),
          _buildDiscoverTab(),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: const Color(0xFF1A5F2A),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.create),
            label: 'Create League',
            onTap: () => context.go('/league/create'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.qr_code),
            label: 'Join by Code',
            onTap: () => _showJoinDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildMyLeaguesTab() {
    return BlocBuilder<LeagueBloc, LeagueState>(
      builder: (context, state) {
        if (state is UserLeaguesLoaded) {
          if (state.leagues.isEmpty) {
            return _buildEmptyState('No leagues yet', 'Create or join a league to start competing');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.leagues.length,
            itemBuilder: (context, index) => LeagueCard(
              league: state.leagues[index],
            ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildDiscoverTab() {
    return BlocBuilder<LeagueBloc, LeagueState>(
      builder: (context, state) {
        if (state is PublicLeaguesLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.leagues.length,
            itemBuilder: (context, index) => LeagueCard(
              league: state.leagues[index],
              showJoinButton: true,
            ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 64, color: Color(0xFF5A6578)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Color(0xFF8B95A5))),
        ],
      ),
    );
  }

  void _showJoinDialog() {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join League'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            hintText: 'Enter invite code',
            prefixIcon: Icon(Icons.vpn_key),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // Join league logic
              Navigator.pop(context);
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
