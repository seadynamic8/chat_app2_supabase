import 'package:flutter/material.dart';

import 'package:chat_app2_supabase/utils/constants.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.username,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.isFirstInSequence = true,
  });

  final String? username;
  final String userId;
  final String content;
  final String createdAt;
  final bool isFirstInSequence;

  bool get isMe {
    final currentUserId = supabase.auth.currentUser!.id;
    return userId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (username != null && isFirstInSequence)
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13),
            child: Text(
              username!,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[300]
                : themeContext.colorScheme.secondary.withAlpha(200),
            borderRadius: BorderRadius.only(
              topLeft: !isMe && isFirstInSequence
                  ? Radius.zero
                  : const Radius.circular(12),
              topRight: isMe && isFirstInSequence
                  ? Radius.zero
                  : const Radius.circular(12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(
            content,
            style: TextStyle(
              height: 1.3,
              color:
                  isMe ? Colors.black87 : themeContext.colorScheme.onSecondary,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
