import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_model.dart';
import '../services/local_storage_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String title;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.title,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isThinking = false;
  final LocalStorageService _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    // Load existing messages for this chat
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final chats = await _storage.loadChats();
    final chat = chats.where((item) => item.id == widget.chatId).firstOrNull;
    if (!mounted) return;
    setState(() => _messages = chat?.messages ?? []);
  }

  Future<void> _saveMessages() async {
    final chats = await _storage.loadChats();
    final index = chats.indexWhere((chat) => chat.id == widget.chatId);
    if (index == -1) return;
    chats[index] = chats[index].copyWith(
      messages: List<Message>.from(_messages),
      updatedAt: DateTime.now(),
    );
    await _storage.saveChats(chats);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        sender: 'user',
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(newMessage);
        _isThinking = true;
      });

      _messageController.clear();
      _saveMessages();
      _scrollToBottom();

      // Simulate AI response after a delay
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        final aiResponse = Message(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          content: 'This is a simulated AI response to: "$text"',
          sender: 'ai',
          timestamp: DateTime.now(),
        );

        setState(() {
          _messages.add(aiResponse);
          _isThinking = false;
        });
        _saveMessages();
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Clear conversation',
            onPressed: _messages.isEmpty
                ? null
                : () => setState(() => _messages.clear()),
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 42,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 12),
                        const Text('What would you like to explore?',
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isUser = message.sender == 'user';
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                             color: isUser 
                                 ? Theme.of(context).colorScheme.primary 
                                 : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(maxWidth: 320),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message.content,
                                style: TextStyle(
                                  color: isUser 
                                      ? Theme.of(context).colorScheme.onPrimary 
                                      : Colors.black87,
                                ),
                              ),
                              if (!isUser)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    tooltip: 'Copy response',
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.copy_outlined,
                                        size: 16),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: message.content));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Response copied')),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isUser 
                                      ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7)
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_isThinking)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('AI is thinking...',
                    style: TextStyle(color: Color(0xFF668084))),
              ),
            ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask anything...',
                      prefixIcon: Icon(Icons.chat_outlined),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Send message',
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}