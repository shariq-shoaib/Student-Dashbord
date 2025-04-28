import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../widgets/chat_message_bubble.dart';
import '../utils/theme.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const ChatScreen({super.key, required this.roomId, required this.roomName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _messages.addAll([
        ChatMessage(
          id: '1',
          roomId: widget.roomId,
          senderId: 'user1',
          senderName: 'John Doe',
          content: 'Hello everyone! How are you doing?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: '2',
          roomId: widget.roomId,
          senderId: 'user2',
          senderName: 'Jane Smith',
          content: "I'm doing great! Working on the math assignment.",
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: true,
        ),
        ChatMessage(
          id: '3',
          roomId: widget.roomId,
          senderId: 'user3',
          senderName: 'Mike Johnson',
          content: "Has anyone finished problem 5? I'm stuck.",
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: true,
        ),
        ChatMessage(
          id: '4',
          roomId: widget.roomId,
          senderId: 'user1',
          senderName: 'John Doe',
          content: "I just finished it. It was tricky!",
          timestamp: DateTime.now(),
          isRead: false,
        ),
      ]);
    });
    _scrollToBottom();
  }

  Future<void> _refreshMessages() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_messages.isNotEmpty) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            id: 'new',
            roomId: widget.roomId,
            senderId: 'user4',
            senderName: 'Sarah Williams',
            content: 'Just joined the chat!',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            isRead: true,
          ),
        );
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: widget.roomId,
      senderId: 'currentUser',
      senderName: 'You',
      content: text,
      timestamp: DateTime.now(),
      isRead: true,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });
    _scrollToBottom();
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
        title: Text(widget.roomName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withOpacity(0.05), AppColors.background],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshMessages,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                color: Colors.white,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ChatMessageBubble(
                      message: message,
                      isMe: message.senderId == 'currentUser',
                    );
                  },
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              // Show attachment options
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
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
    _focusNode.dispose();
    super.dispose();
  }
}
