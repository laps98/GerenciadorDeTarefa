import 'package:flutter/material.dart';

class ConfirmDialog {
  static void show({
    required BuildContext context,
    required String message,
    required Function callbackSuccess,
    required Function callbackError,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(onPressed: () => callbackError(), child: const Text('Não')),
          TextButton(onPressed: () => callbackSuccess(), child: const Text('Sim')),
        ],
      ),
    );
  }
}
