import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/league.dart';
import '../bloc/league_bloc.dart';

class CreateLeaguePage extends StatefulWidget {
  const CreateLeaguePage({super.key});

  @override
  State<CreateLeaguePage> createState() => _CreateLeaguePageState();
}

class _CreateLeaguePageState extends State<CreateLeaguePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = false;
  String? _competitionFilter;

  final List<String> _competitions = [
    'All Competitions',
    'Premier League',
    'La Liga',
    'Champions League',
    'World Cup',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create League')),
      body: BlocListener<LeagueBloc, LeagueState>(
        listener: (context, state) {
          if (state is LeagueCreated) {
            context.go('/league/${state.league.id}');
          } else if (state is LeagueError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'League Name',
                    hintText: 'e.g., Office Premier League',
                    prefixIcon: Icon(Icons.emoji_events),
                  ),
                  validator: (v) => v?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'What is this league about?',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _competitionFilter,
                  decoration: const InputDecoration(
                    labelText: 'Competition Filter',
                    prefixIcon: Icon(Icons.filter_list),
                  ),
                  items: _competitions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _competitionFilter = v),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Public League'),
                  subtitle: const Text('Anyone can discover and join'),
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _createLeague,
                    child: const Text('Create League', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createLeague() {
    if (_formKey.currentState?.validate() ?? false) {
      final league = League(
        id: '',
        name: _nameController.text,
        description: _descriptionController.text,
        ownerId: 'current_user_id',
        createdAt: DateTime.now(),
        isPublic: _isPublic,
        competitionFilter: _competitionFilter,
      );
      context.read<LeagueBloc>().add(CreateLeagueEvent(league));
    }
  }
}
