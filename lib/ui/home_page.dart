import 'package:dart_client_for_genkit_sample/ui/pages/process_object_page.dart';
import 'package:dart_client_for_genkit_sample/ui/pages/simple_string_page.dart';
import 'package:dart_client_for_genkit_sample/ui/pages/stream_objects_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 48,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Dart client for Genkit - Demo App',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Explore different Genkit flows and see how they work in real-time',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Available Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _ActionCard(
                      title: 'Simple String Action',
                      description:
                          'Send a string input and receive a processed string response',
                      icon: Icons.text_fields,
                      color: Colors.blue,
                      onTap: () => _navigateTo(context, SimpleStringPage()),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      title: 'Process Object Action',
                      description:
                          'Send structured data (message + count) and receive processed output',
                      icon: Icons.data_object,
                      color: Colors.green,
                      onTap: () => _navigateTo(context, ProcessObjectPage()),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      title: 'Stream Objects Action',
                      description:
                          'Send a prompt and receive streaming responses in real-time',
                      icon: Icons.stream,
                      color: Colors.orange,
                      onTap: () => _navigateTo(context, StreamObjectsPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
