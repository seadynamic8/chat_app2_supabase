import 'package:flutter/material.dart';

import 'package:chat_app2_supabase/utils/constants.dart';

class MessageBubble extends StatefulWidget {
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

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool get isMe {
    final currentUserId = supabase.auth.currentUser!.id;
    return widget.userId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (widget.username != null && widget.isFirstInSequence)
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13),
            child: Text(
              widget.username!,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: const BoxConstraints(maxWidth: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Text(widget.content),
        ),
      ],
    );
  }
}
