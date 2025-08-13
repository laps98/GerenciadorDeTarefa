import 'package:flutter/material.dart';

class LoadingDialog {
  static void show({
    required BuildContext context,
    String mensagem = 'Salvando',
  }) {
    AlertDialog alert = AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const CircularProgressIndicator(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(mensagem),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}
