import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/chat_screen.dart';
import 'screens/code_editor_screen.dart';
import 'screens/ai_tools_screen.dart';
import 'screens/workflow_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/chat_detail_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Studio Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/chat-detail/:chatId',
        builder: (context, state) => ChatDetailScreen(
          chatId: state.pathParameters['chatId']!,
          title: state.queryParameters['title'] ?? 'Chat',
        ),
      ),
    ],
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    ChatScreen(),
    CodeEditorScreen(),
    AIToolsScreen(),
    WorkflowScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Workflow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}