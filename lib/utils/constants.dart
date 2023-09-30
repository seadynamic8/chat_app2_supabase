import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar(String errorMessage,
      {Color backgroundColor = Colors.white}) {
    final sMessenger = ScaffoldMessenger.of(this);
    sMessenger.clearSnackBars();
    sMessenger.showSnackBar(SnackBar(
      content: Text(errorMessage),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar(String errorMessage) {
    showSnackBar(errorMessage, backgroundColor: Colors.red);
  }
}
