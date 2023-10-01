import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:chat_app2_supabase/utils/constants.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) {
      context.showSnackBar('Please enter a message');
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final userId = supabase.auth.currentUser!.id;

    try {
      await supabase
          .from('messages')
          .insert({'user_id': userId, 'content': messageText});

      if (!mounted) return;
    } on AuthException catch (error) {
      context.showErrorSnackBar(error.message);
    } catch (error) {
      context.showErrorSnackBar('Unable to create message. Try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              autocorrect: true,
              decoration: const InputDecoration(hintText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
