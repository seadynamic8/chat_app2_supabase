import 'package:chat_app2_supabase/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

import 'package:chat_app2_supabase/utils/constants.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id']).order('created_at', ascending: false);

    return StreamBuilder(
      stream: messagesStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong retrieving messages.'),
          );
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Start chatting :)'),
          );
        }

        final List<Map<String, dynamic>> messages = snapshot.data!;

        return ListView.builder(
          itemCount: messages.length,
          reverse: true,
          itemBuilder: (ctx, index) {
            final message = messages[index];
            return MessageBubble(
              userId: message['user_id'],
              content: message['content'],
              createdAt: message['created_at'],
            );
          },
        );
      },
    );
  }
}
