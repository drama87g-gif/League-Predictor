import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../domain/entities/match.dart';
import '../bloc/matches_bloc.dart';
import '../../../../core/utils/helpers.dart';

class PredictionPage extends StatefulWidget {
  final String matchId;
  const PredictionPage({super.key, required this.matchId});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  String? _selectedType;
  String? _selectedValue;
  late ConfettiController _confettiController;

  final Map<String, List<String>> _predictionOptions = {
    'match_winner': ['Home Win', 'Draw', 'Away Win'],
    'exact_score': [], // Custom input
    'btts': ['Yes', 'No'],
    'over_under': ['Over 2.5', 'Under 2.5'],
    'clean_sheet': ['Home', 'Away', 'Neither'],
  };

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    context.read<MatchesBloc>().add(LoadMatchDetails(widget.matchId));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _submitPrediction() {
    if (_selectedType == null || _selectedValue == null) return;

    final prediction = Prediction(
      id: Helpers.generateId(),
      matchId: widget.matchId,
      userId: 'current_user_id', // Get from auth bloc
      predictionType: _selectedType!,
      value: _selectedValue!,
      potentialPoints: 5,
      createdAt: DateTime.now(),
    );

    context.read<MatchesBloc>().add(SubmitPrediction(prediction));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make Prediction')),
      body: BlocConsumer<MatchesBloc, MatchesState>(
        listener: (context, state) {
          if (state is PredictionSubmitted) {
            _confettiController.play();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Prediction submitted successfully!'),
                backgroundColor: Color(0xFF2ECC71),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () => context.pop());
          } else if (state is PredictionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: const Color(0xFFE63946)),
            );
          }
        },
        builder: (context, state) {
          if (state is MatchDetailsLoaded) {
            final match = state.match;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMatchHeader(match),
                      const SizedBox(height: 24),
                      Text('Select Prediction Type', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      ...match.availablePredictions.map((type) => _buildPredictionTypeCard(type)),
                      const SizedBox(height: 24),
                      if (_selectedType != null) ...[
                        Text('Your Prediction', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        _buildValueSelector(),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _selectedType != null && _selectedValue != null ? _submitPrediction : null,
                          child: const Text('Submit Prediction', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.05,
                    emissionFrequency: 0.05,
                    numberOfParticles: 50,
                    gravity: 0.2,
                    colors: const [Color(0xFFF5A623), Color(0xFF1A5F2A), Color(0xFF00B4D8), Colors.white],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildMatchHeader(Match match) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A5F2A), Color(0xFF2E8B47)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTeamColumn(match.homeTeam.name, match.homeTeam.crestUrl),
          const Text('VS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          _buildTeamColumn(match.awayTeam.name, match.awayTeam.crestUrl),
        ],
      ),
    );
  }

  Widget _buildTeamColumn(String name, String? crestUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white24,
          child: crestUrl != null
              ? Image.network(crestUrl, width: 32, height: 32)
              : Text(name.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildPredictionTypeCard(PredictionType type) {
    final isSelected = _selectedType == type.id;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedType = type.id;
        _selectedValue = null;
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A5F2A).withOpacity(0.2) : const Color(0xFF1A1F2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E8B47) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A5F2A) : const Color(0xFF252B3B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Colors.white : const Color(0xFF5A6578),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Helpers.formatPredictionType(type.id), style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(type.description, style: const TextStyle(color: Color(0xFF8B95A5), fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5A623).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('+${type.points}', style: const TextStyle(color: Color(0xFFF5A623), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildValueSelector() {
    if (_selectedType == 'exact_score') {
      return Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: '0'),
              onChanged: (v) => setState(() => _selectedValue = '$v-$_selectedValue?.split("-")[1]??0'),
            ),
          ),
          const Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: '0'),
              onChanged: (v) => setState(() => _selectedValue = '${_selectedValue?.split("-")[0]??0}-$v'),
            ),
          ),
        ],
      );
    }

    final options = _predictionOptions[_selectedType] ?? [];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = _selectedValue == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedValue = option),
          selectedColor: const Color(0xFF1A5F2A),
          backgroundColor: const Color(0xFF252B3B),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8B95A5),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
