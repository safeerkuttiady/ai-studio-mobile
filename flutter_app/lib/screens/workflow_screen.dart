import 'package:flutter/material.dart';

class WorkflowScreen extends StatefulWidget {
  const WorkflowScreen({super.key});

  @override
  State<WorkflowScreen> createState() => _WorkflowScreenState();
}

class _WorkflowScreenState extends State<WorkflowScreen> {
  final List<_WorkflowItem> _workflows = [
    _WorkflowItem(id: '1', name: 'Daily Tasks', description: 'Track daily activities', isActive: true),
    _WorkflowItem(id: '2', name: 'Project Planning', description: 'Plan and manage projects', isActive: false),
    _WorkflowItem(id: '3', name: 'AI Automation', description: 'Automate repetitive tasks', isActive: true),
  ];

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
                    decoration: const InputDecoration(
                      hintText: 'Search workflows...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    // TODO: Implement workflow creation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Create new workflow would happen here')),
                    );
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _workflows.length,
                itemBuilder: (context, index) {
                  final workflow = _workflows[index];
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
                              const Text(
                                'Status: Active',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text('Last run: Today, 10:30 AM'),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement workflow edit
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Edit workflow would happen here')),
                                      );
                                    },
                                    child: const Text('EDIT'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement workflow run
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Run workflow would happen here')),
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
}

class _WorkflowItem {
  final String id;
  final String name;
  final String description;
  final bool isActive;

  _WorkflowItem({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });
}