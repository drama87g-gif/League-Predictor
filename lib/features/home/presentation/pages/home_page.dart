import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _destinations = [
    const _NavDestination(icon: Icons.sports_soccer, label: 'Matches', path: '/matches'),
    const _NavDestination(icon: Icons.emoji_events, label: 'Leagues', path: '/leagues'),
    const _NavDestination(icon: Icons.leaderboard, label: 'Rankings', path: '/leaderboard'),
    const _NavDestination(icon: Icons.person, label: 'Profile', path: '/profile'),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    context.go(_destinations[index].path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_destinations.length, (index) {
                final dest = _destinations[index];
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1A5F2A).withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          dest.icon,
                          color: isSelected ? const Color(0xFF2E8B47) : const Color(0xFF5A6578),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dest.label,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF2E8B47) : const Color(0xFF5A6578),
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  final IconData icon;
  final String label;
  final String path;
  const _NavDestination({required this.icon, required this.label, required this.path});
}

// Tab Placeholders
class MatchesTab extends StatelessWidget {
  const MatchesTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Matches'));
}

class LeaguesTab extends StatelessWidget {
  const LeaguesTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Leagues'));
}

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Leaderboard'));
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Profile'));
}
