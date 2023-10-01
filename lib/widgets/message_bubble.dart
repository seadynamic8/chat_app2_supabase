import 'package:flutter/material.dart';

import 'package:chat_app2_supabase/utils/constants.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  final String userId;
  final String content;
  final String createdAt;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Map<String, String> userData = {};

  @override
  void initState() {
    super.initState();

    _getUserData();
  }

  void _getUserData() async {
    final data = await supabase
        .from('profiles')
        .select('username')
        .eq('id', widget.userId)
        .single();

    setState(() {
      userData['username'] = data['username'] as String;
    });
  }

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
        if (userData['username'] != null)
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13),
            child: Text(userData['username']!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                )),
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
