import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:chat_app2_supabase/secrets.dart';
import 'package:chat_app2_supabase/screens/splash.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      authFlowType: AuthFlowType.pkce,
    );

    runApp(const MyChatApp());
  }, (error, stack) => print(error));
}

class MyChatApp extends StatelessWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
