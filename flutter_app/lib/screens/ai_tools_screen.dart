import 'package:flutter/material.dart';

class AIToolsScreen extends StatefulWidget {
  const AIToolsScreen({super.key});

  @override
  State<AIToolsScreen> createState() => _AIToolsScreenState();
}

class _AIToolsScreenState extends State<AIToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tools'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Access various AI-powered tools',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildToolCard(
                    icon: Icons.auto_fix_high,
                    title: 'Text Generator',
                    onTap: () {
                      // TODO: Implement text generator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Text Generator would open here')),
                      );
                    },
                  ),
                  _buildToolCard(
                    icon: Icons.image,
                    title: 'Image Generator',
                    onTap: () {
                      // TODO: Implement image generator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image Generator would open here')),
                      );
                    },
                  ),
                  _buildToolCard(
                    icon: Icons.music_note,
                    title: 'Music Generator',
                    onTap: () {
                      // TODO: Implement music generator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Music Generator would open here')),
                      );
                    },
                  ),
                  _buildToolCard(
                    icon: Icons.movie,
                    title: 'Video Generator',
                    onTap: () {
                      // TODO: Implement video generator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Video Generator would open here')),
                      );
                    },
                  ),
                  _buildToolCard(
                    icon: Icons.code,
                    title: 'Code Assistant',
                    onTap: () {
                      // TODO: Implement code assistant
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code Assistant would open here')),
                      );
                    },
                  ),
                  _buildToolCard(
                    icon: Icons.translate,
                    title: 'Language Translator',
                    onTap: () {
                      // TODO: Implement translator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Language Translator would open here')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue[400]),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}