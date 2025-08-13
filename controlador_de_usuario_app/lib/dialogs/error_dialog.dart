import 'package:flutter/material.dart';

class ErrorDialog {
  static void show({
    required BuildContext context,
    required String message,
    String? title = 'Erro',
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actionsPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.only(top: 16, bottom: 8, right: 16, left: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
