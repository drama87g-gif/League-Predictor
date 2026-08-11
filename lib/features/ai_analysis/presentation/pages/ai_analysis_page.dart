import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../bloc/ai_analysis_bloc.dart';

class AiAnalysisPage extends StatefulWidget {
  final String matchId;
  const AiAnalysisPage({super.key, required this.matchId});

  @override
  State<AiAnalysisPage> createState() => _AiAnalysisPageState();
}

class _AiAnalysisPageState extends State<AiAnalysisPage> {
  @override
  void initState() {
    super.initState();
    context.read<AiAnalysisBloc>().add(LoadAiAnalysis(widget.matchId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Match Analysis')),
      body: BlocBuilder<AiAnalysisBloc, AiAnalysisState>(
        builder: (context, state) {
          if (state is AiAnalysisLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AiAnalysisLoaded) {
            final analysis = state.analysis;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConfidenceBadge(analysis.confidenceScore),
                  const SizedBox(height: 24),
                  _buildProbabilityBars(analysis),
                  const SizedBox(height: 24),
                  _buildRecommendationCard(analysis.recommendedPrediction),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Key Factors'),
                  const SizedBox(height: 12),
                  ...analysis.keyFactors.map((factor) => _buildFactorCard(factor)),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Squad News'),
                  const SizedBox(height: 12),
                  _buildSquadNews(analysis.injuries, analysis.suspensions),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Tactical Preview'),
                  const SizedBox(height: 12),
                  _buildInfoCard(analysis.tacticalPreview ?? 'No tactical preview available'),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Referee & Conditions'),
                  const SizedBox(height: 12),
                  _buildInfoCard('${analysis.refereeTrends ?? ""}\n\n${analysis.weatherImpact ?? ""}'),
                  const SizedBox(height: 24),
                  _buildReasoningCard(analysis.reasoning),
                ],
              ),
            );
          }
          return const Center(child: Text('Failed to load analysis'));
        },
      ),
    );
  }

  Widget _buildConfidenceBadge(double score) {
    Color color;
    String label;
    if (score >= 0.8) {
      color = const Color(0xFF2ECC71);
      label = 'Very High Confidence';
    } else if (score >= 0.6) {
      color = const Color(0xFFF5A623);
      label = 'High Confidence';
    } else {
      color = const Color(0xFFE63946);
      label = 'Moderate Confidence';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '${(score * 100).toInt()}%',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _buildProbabilityBars(dynamic analysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProbabilityRow('Home Win', analysis.homeWinProbability, const Color(0xFF1A5F2A)),
            const SizedBox(height: 12),
            _buildProbabilityRow('Draw', analysis.drawProbability, const Color(0xFFF5A623)),
            const SizedBox(height: 12),
            _buildProbabilityRow('Away Win', analysis.awayWinProbability, const Color(0xFFDC052D)),
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilityRow(String label, double probability, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('${(probability * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          percent: probability,
          progressColor: color,
          backgroundColor: const Color(0xFF252B3B),
          lineHeight: 8,
          barRadius: const Radius.circular(4),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(String recommendation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A5F2A), Color(0xFF2E8B47)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('AI Recommendation', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            recommendation,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildFactorCard(String factor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF2E8B47), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(factor, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildSquadNews(List<String> injuries, List<String> suspensions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (injuries.isNotEmpty) ...[
              const Text('Injuries', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE63946))),
              const SizedBox(height: 8),
              ...injuries.map((i) => _buildNewsItem(i, Icons.local_hospital, const Color(0xFFE63946))),
              const SizedBox(height: 16),
            ],
            if (suspensions.isNotEmpty) ...[
              const Text('Suspensions', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFF5A623))),
              const SizedBox(height: 8),
              ...suspensions.map((s) => _buildNewsItem(s, Icons.block, const Color(0xFFF5A623))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
    );
  }

  Widget _buildReasoningCard(String reasoning) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252B3B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A5F2A).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Color(0xFF00B4D8)),
              SizedBox(width: 8),
              Text('AI Reasoning', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(reasoning, style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF8B95A5))),
        ],
      ),
    );
  }
}
