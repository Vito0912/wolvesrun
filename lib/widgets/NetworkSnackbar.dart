import 'package:flutter/material.dart';

class NetworkSnackbar {
  static void showSnackbar(BuildContext context, SnackbarType type,
      List<String> messages, String title) {
    final color = _getColor(context, type);
    final icon = _getIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Row(
          children: [
            Icon(icon, color: Theme.of(context).scaffoldBackgroundColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, // This is the title
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).scaffoldBackgroundColor)),
                  ...messages.map((message) => Text(message,
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor))),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Color _getColor(BuildContext context, SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return Theme.of(context).colorScheme.error;
      case SnackbarType.warning:
        return Colors.orange;
      case SnackbarType.success:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.warning:
        return Icons.warning_amber_outlined;
      case SnackbarType.success:
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }
}

enum SnackbarType { error, warning, success }
