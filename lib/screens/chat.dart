import 'package:flutter/material.dart';

import 'package:chat_app2_supabase/utils/constants.dart';
import 'package:chat_app2_supabase/screens/splash.dart';
import 'package:chat_app2_supabase/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _logout() async {
    await supabase.auth.signOut();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const SplashScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: Text('Chat Messages'),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
