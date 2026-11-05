import 'package:flutter/material.dart';

class AIToolsScreen extends StatefulWidget {
  const AIToolsScreen({super.key});

  @override
  State<AIToolsScreen> createState() => _AIToolsScreenState();
}

class _AIToolsScreenState extends State<AIToolsScreen> {
  void _openTool(String title) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Describe what you want to create.'),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Your prompt'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('$title is ready to run locally')),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate'),
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(controller.dispose);
  }

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
                    onTap: () => _openTool('Text Generator'),
                  ),
                  _buildToolCard(
                    icon: Icons.image,
                    title: 'Image Generator',
                    onTap: () => _openTool('Image Generator'),
                  ),
                  _buildToolCard(
                    icon: Icons.music_note,
                    title: 'Music Generator',
                    onTap: () => _openTool('Music Generator'),
                  ),
                  _buildToolCard(
                    icon: Icons.movie,
                    title: 'Video Generator',
                    onTap: () => _openTool('Video Generator'),
                  ),
                  _buildToolCard(
                    icon: Icons.code,
                    title: 'Code Assistant',
                    onTap: () => _openTool('Code Assistant'),
                  ),
                  _buildToolCard(
                    icon: Icons.translate,
                    title: 'Language Translator',
                    onTap: () => _openTool('Language Translator'),
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
      elevation: 0,
      color: Colors.white,
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