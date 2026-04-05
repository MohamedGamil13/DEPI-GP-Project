import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class AppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: _getColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar); // if there A SNAck bar in the screen already
  }

  static Color _getColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.info:
        return Colors.blue;
    }
  }

  // Shortcuts for easier usage in the app

  static void success(BuildContext context, String message) {
    show(context, message, type: SnackBarType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message, type: SnackBarType.error);
  }

  static void info(BuildContext context, String message) {
    show(context, message, type: SnackBarType.info);
  }
}

//reviewed
