import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../bloc/matches_bloc.dart';
import '../widgets/match_card.dart';
import '../widgets/competition_filter_chip.dart';
import '../widgets/date_selector.dart';

class MatchesTab extends StatefulWidget {
  const MatchesTab({super.key});

  @override
  State<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends State<MatchesTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _competitions = ['All', 'Premier League', 'La Liga', 'Serie A', 'Bundesliga', 'Champions League'];
  String _selectedCompetition = 'All';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    context.read<MatchesBloc>().add(LoadFeaturedMatches());
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          context.read<MatchesBloc>().add(LoadLiveMatches());
          break;
        case 1:
          context.read<MatchesBloc>().add(FilterMatchesByDate(DateTime.now()));
          break;
        case 2:
          context.read<MatchesBloc>().add(LoadMatches(status: 'SCHEDULED'));
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              title: const Text('Matches'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'LIVE'),
                  Tab(text: 'TODAY'),
                  Tab(text: 'UPCOMING'),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLiveTab(),
                  _buildTodayTab(),
                  _buildUpcomingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _competitions.length,
        itemBuilder: (context, index) {
          final competition = _competitions[index];
          final isSelected = _selectedCompetition == competition;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CompetitionFilterChip(
              label: competition,
              isSelected: isSelected,
              onTap: () {
                setState(() => _selectedCompetition = competition);
                if (competition == 'All') {
                  context.read<MatchesBloc>().add(const LoadMatches());
                } else {
                  context.read<MatchesBloc>().add(FilterMatchesByCompetition(competition));
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveTab() {
    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (state is MatchesLoading) {
          return _buildShimmerList();
        } else if (state is LiveMatchesLoaded) {
          if (state.matches.isEmpty) {
            return _buildEmptyState('No live matches right now', Icons.sports_soccer);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.matches.length,
            itemBuilder: (context, index) {
              return MatchCard(
                match: state.matches[index],
                isLive: true,
              ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms).slideY(begin: 0.2, end: 0);
            },
          );
        } else if (state is MatchesError) {
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTodayTab() {
    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (state is MatchesLoading) {
          return _buildShimmerList();
        } else if (state is MatchesLoaded) {
          if (state.matches.isEmpty) {
            return _buildEmptyState('No matches today', Icons.calendar_today);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.matches.length,
            itemBuilder: (context, index) {
              return MatchCard(match: state.matches[index])
                  .animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
            },
          );
        } else if (state is MatchesError) {
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUpcomingTab() {
    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (state is MatchesLoading) {
          return _buildShimmerList();
        } else if (state is MatchesLoaded) {
          if (state.matches.isEmpty) {
            return _buildEmptyState('No upcoming matches', Icons.event);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.matches.length,
            itemBuilder: (context, index) {
              return MatchCard(match: state.matches[index])
                  .animate().fadeIn(duration: 300.ms, delay: (index * 50).ms);
            },
          );
        } else if (state is MatchesError) {
          return _buildErrorState(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _ShimmerMatchCard(),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: const Color(0xFF5A6578)),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF8B95A5))),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Color(0xFFE63946)),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF8B95A5))),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<MatchesBloc>().add(LoadFeaturedMatches()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _ShimmerMatchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(height: 12, width: 100, color: const Color(0xFF252B3B)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(height: 40, width: 40, decoration: const BoxDecoration(color: Color(0xFF252B3B), shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Expanded(child: Container(height: 16, color: const Color(0xFF252B3B))),
            ],
          ),
        ],
      ),
    );
  }
}
