import 'package:chat_app2_supabase/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

import 'package:chat_app2_supabase/utils/constants.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final Map<String, Map<String, String?>> userData = {};

  void _loadUserData(String userId) async {
    if (userData[userId] != null) return;

    final data = await supabase
        .from('profiles')
        .select('username')
        .eq('id', userId)
        .single();

    setState(() {
      userData[userId] = {'username': data['username'] as String};
    });
  }

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
            final nextMessage =
                index + 1 < messages.length ? messages[index + 1] : null;

            final messageUserId = message['user_id'];
            final nextMessageUserId =
                nextMessage != null ? nextMessage['user_id'] : null;

            final firstInSequence = messageUserId != nextMessageUserId;

            _loadUserData(messageUserId);

            return MessageBubble(
              username: userData[messageUserId] == null
                  ? null
                  : userData[messageUserId]!['username'],
              userId: message['user_id'],
              content: message['content'],
              createdAt: message['created_at'],
              isFirstInSequence: firstInSequence,
            );
          },
        );
      },
    );
  }
}
