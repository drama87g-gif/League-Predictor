import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/matches_bloc.dart';

class PredictionSummary extends StatelessWidget {
  final String matchId;
  const PredictionSummary({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (state is UserPredictionsLoaded) {
          final predictions = state.predictions.where((p) => p.matchId == matchId).toList();
          if (predictions.isEmpty) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('You have not made any predictions for this match yet.'),
              ),
            );
          }
          return Column(
            children: predictions.map((prediction) {
              return ListTile(
                title: Text(prediction.predictionType),
                subtitle: Text('Your pick: ${prediction.value}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: prediction.isCorrect
                        ? const Color(0xFF2ECC71).withOpacity(0.2)
                        : const Color(0xFF252B3B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prediction.isCorrect
                        ? '+${prediction.earnedPoints}'
                        : '+${prediction.potentialPoints}',
                    style: TextStyle(
                      color: prediction.isCorrect
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFF5A623),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
