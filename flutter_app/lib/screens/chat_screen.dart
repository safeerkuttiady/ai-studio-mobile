import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/firebase_service.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatService chatService;

  ChatScreen({super.key, ChatService? chatService})
      : chatService = chatService ?? FirebaseService();

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Chat> _chats = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final LocalStorageService _storage = LocalStorageService();
  final List<Chat> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final chats = await widget.chatService.getAllChatsFromFirestore();
      setState(() {
        _chats = chats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading chats: $e')),
      );
    }
  }

  void _createNewChat() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Give your conversation a name first.')),
      );
      return;
    }
    final chat = Chat(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    setState(() => _chats.insert(0, chat));
    _storage.saveChats(_chats);
    _controller.clear();
    _openChat(chat);
  }

    try {
      await widget.chatService.saveChatToFirestore(newChat);
      _controller.clear();
      _loadChats(); // Refresh the list
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailScreen(
            chatId: newChat.id,
            title: newChat.title,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create chat: $e')),
      );
    }
  }

  Future<void> _deleteChat(Chat chat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete conversation?'),
        content: Text('Remove "${chat.title}" from this device?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await widget.chatService.deleteChatFromFirestore(chatId);
        _loadChats();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete chat: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        actions: [
          IconButton(
              tooltip: 'New conversation',
              onPressed: _createNewChat,
              icon: const Icon(Icons.add_comment_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A calm space for clear thinking',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF668084))),
            const SizedBox(height: 18),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search conversations',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _createNewChat(),
                    decoration: const InputDecoration(
                        hintText: 'Name a new conversation',
                        prefixIcon: Icon(Icons.edit_outlined)),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                    tooltip: 'Create conversation',
                    onPressed: _createNewChat,
                    icon: const Icon(Icons.arrow_forward)),
              ],
            ),
            const SizedBox(height: 26),
            Text('Recent', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredChats.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.forum_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 14),
                          const Text('Your ideas start here',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          const Text('Create a conversation above to begin',
                              style: TextStyle(color: Color(0xFF668084))),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredChats.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final chat = _filteredChats[index];
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            leading: CircleAvatar(
                                backgroundColor: const Color(0xFFD9F1F0),
                                child: Icon(Icons.chat_bubble_outline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary)),
                            title: Text(chat.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text('Updated ${chat.updatedAt!.day}/'
                                '${chat.updatedAt!.month}/${chat.updatedAt!.year}'),
                            trailing: IconButton(
                                tooltip: 'Delete conversation',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteChat(chat)),
                            onTap: () => _openChat(chat),
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

  List<Chat> get _filteredChats {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _chats;
    return _chats
        .where((chat) => chat.title.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }
}