import 'package:flutter/material.dart';

class WorkflowScreen extends StatefulWidget {
  const WorkflowScreen({super.key});

  @override
  State<WorkflowScreen> createState() => _WorkflowScreenState();
}

class _WorkflowScreenState extends State<WorkflowScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<_WorkflowItem> _workflows = [
    _WorkflowItem(id: '1', name: 'Daily Tasks', description: 'Track daily activities', isActive: true),
    _WorkflowItem(id: '2', name: 'Project Planning', description: 'Plan and manage projects', isActive: false),
    _WorkflowItem(id: '3', name: 'AI Automation', description: 'Automate repetitive tasks', isActive: true),
  ];

  void _createWorkflow() {
    final nameController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New workflow'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Workflow name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() => _workflows.add(_WorkflowItem(
                    id: DateTime.now().toString(),
                    name: nameController.text.trim(),
                    description: 'New personal automation',
                    isActive: false)));
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    ).whenComplete(nameController.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflows'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage your automated workflows',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search workflows...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Create workflow',
                  onPressed: _createWorkflow,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _workflows
                  .where((workflow) => workflow.name.toLowerCase().contains(
                    _searchController.text.trim().toLowerCase()))
                  .length,
                itemBuilder: (context, index) {
                  final workflow = _workflows
                    .where((workflow) => workflow.name.toLowerCase().contains(
                      _searchController.text.trim().toLowerCase()))
                    .elementAt(index);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: workflow.isActive ? Colors.green : Colors.grey,
                        child: Icon(
                          workflow.isActive ? Icons.check : Icons.schedule,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(workflow.name),
                      subtitle: Text(workflow.description),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: ${workflow.isActive ? 'Active' : 'Paused'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text('Last run: ${workflow.lastRun}'),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() => workflow.isActive = !workflow.isActive);
                                    },
                                    child: const Text('EDIT'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() => workflow.lastRun = 'Just now');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${workflow.name} ran successfully')),
                                      );
                                    },
                                    child: const Text('RUN'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _WorkflowItem {
  final String id;
  final String name;
  final String description;
  bool isActive;
  String lastRun = 'Today, 10:30 AM';

  _WorkflowItem({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });
}