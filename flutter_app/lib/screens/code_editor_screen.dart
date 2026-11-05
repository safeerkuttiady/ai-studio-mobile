import 'package:flutter/material.dart';

import '../models/code_file.dart';
import '../services/local_storage_service.dart';

class CodeEditorScreen extends StatefulWidget {
  const CodeEditorScreen({super.key});

  @override
  State<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends State<CodeEditorScreen> {
  final TextEditingController _codeController = TextEditingController();
  final LocalStorageService _storage = LocalStorageService();
  String _language = 'Dart';
  String _status = 'Ready';

  @override
  void initState() {
    super.initState();
    _loadCode();
  }

  Future<void> _loadCode() async {
    try {
      final code = await _storage.loadCode();
      if (!mounted) return;
      _codeController.text = code;
    } catch (error) {
      if (mounted) _showMessage('Could not load your draft: $error');
    }
  }

  Future<void> _saveSnippet() async {
    final titleController = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save snippet'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.pop(context, value.trim()),
          decoration: const InputDecoration(labelText: 'Snippet name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, titleController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    titleController.dispose();

    if (!mounted || title == null) return;
    if (title.isEmpty) {
      _showMessage('Enter a name for your snippet.');
      return;
    }

    final now = DateTime.now();
    final snippet = CodeFile(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      language: _language,
      content: _codeController.text,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _storage.saveCodeFile(snippet);
      await _storage.saveCode(_codeController.text);
      if (!mounted) return;
      setState(() => _status = 'Saved just now');
      _showMessage('“$title” saved on this device.');
    } catch (error) {
      if (mounted) _showMessage('Could not save snippet: $error');
    }
  }

  Future<void> _openSnippets() async {
    try {
      final snippets = await _storage.getCodeFiles();
      if (!mounted) return;
      final selected = await showModalBottomSheet<CodeFile>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: snippets.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No saved snippets yet. Save your code to find it here.'),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: snippets.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final snippet = snippets[index];
                    return ListTile(
                      leading: const Icon(Icons.code),
                      title: Text(snippet.title),
                      subtitle: Text(snippet.language),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pop(context, snippet),
                    );
                  },
                ),
        ),
      );
      if (selected == null || !mounted) return;
      setState(() {
        _codeController.text = selected.content;
        _language = selected.language;
        _status = 'Opened ${selected.title}';
      });
    } catch (error) {
      if (mounted) _showMessage('Could not load saved snippets: $error');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor'),
        actions: [
          IconButton(
            tooltip: 'Open saved snippets',
            onPressed: _openSnippets,
            icon: const Icon(Icons.folder_open_outlined),
          ),
          DropdownButton<String>(
            value: _language,
            underline: const SizedBox.shrink(),
            items: const ['Dart', 'JavaScript', 'Python', 'JSON']
                .map((language) => DropdownMenuItem(
                      value: language,
                      child: Text(language),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _language = value);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'A lightweight scratchpad',
                  style: TextStyle(color: Color(0xFF668084)),
                ),
                Text(
                  _status,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: '// Start writing your code here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _saveSnippet,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save snippet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
