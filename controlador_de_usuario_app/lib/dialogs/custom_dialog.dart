import 'package:flutter/material.dart';

class CustomDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required String buttonText,
    required Function callbackSuccess,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(color: Colors.black),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 0),
              child: TextButton(
                onPressed: () => callbackSuccess(),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
