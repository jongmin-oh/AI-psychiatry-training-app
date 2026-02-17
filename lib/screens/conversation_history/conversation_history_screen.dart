import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../widgets/chat_bubble.dart';

class ConversationHistoryScreen extends StatelessWidget {
  final List<ChatMessage> messages;

  const ConversationHistoryScreen({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대화 내역'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          0,
          16,
          0,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ChatBubble(message: messages[index]);
        },
      ),
    );
  }
}
