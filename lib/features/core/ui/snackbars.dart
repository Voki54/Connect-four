import 'package:connect_four/main.dart';
import 'package:flutter/material.dart';

class ResultSnackBar {
  static void showSuccessSnackBar({
    required String message,
  }) {
    _showSnackBar(message: message, backgroundColor: Colors.green);
  }

  static void showFailSnackBar({
    required String message,
  }) {
    _showSnackBar(message: message, backgroundColor: Colors.redAccent);
  }

  static void _showSnackBar({
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 5),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message),
        behavior: behavior,
        duration: duration,
      ),
    );
  }
}
