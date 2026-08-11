import 'package:flutter/material.dart';

class RecentForm extends StatelessWidget {
  final String teamName;
  final List<String> form;

  const RecentForm({super.key, required this.teamName, required this.form});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$teamName - Last 5', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: form.map((result) {
                Color color;
                switch (result) {
                  case 'W':
                    color = const Color(0xFF2ECC71);
                    break;
                  case 'D':
                    color = const Color(0xFFF5A623);
                    break;
                  case 'L':
                    color = const Color(0xFFE63946);
                    break;
                  default:
                    color = const Color(0xFF5A6578);
                }
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      result,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
