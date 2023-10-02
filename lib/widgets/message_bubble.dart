import 'package:flutter/material.dart';

import 'package:chat_app2_supabase/utils/constants.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.avatarUrl,
    required this.username,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.isFirstInSequence = true,
  });

  final String? avatarUrl;
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

    return Stack(
      children: [
        if (avatarUrl != null && isFirstInSequence)
          Positioned(
            top: 15,
            right: isMe ? 0 : null,
            child: CircleAvatar(
              foregroundImage: NetworkImage(avatarUrl!),
              backgroundColor: themeContext.colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence) const SizedBox(height: 18),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Text(
                      content,
                      style: TextStyle(
                        height: 1.3,
                        color: isMe
                            ? Colors.black87
                            : themeContext.colorScheme.onSecondary,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
