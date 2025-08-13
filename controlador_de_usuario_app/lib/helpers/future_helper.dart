import 'package:controlador_de_usuario_app/dialogs/custom_dialog.dart';
import 'package:flutter/material.dart';

import '../components/custom_exception.dart';

extension FutureHelper<T> on Future<T> {
  Future<T> handleError(BuildContext context) {
    return catchError((exception) {
      final message = exception is CustomException ? exception.message : exception.toString();

      CustomDialog.show(
        context: context,
        title: 'Um erro aconteceu',
        message: message,
        buttonText: 'Ok',
        callbackSuccess: () {
          Navigator.of(context).pop();
        },
      );
    });
  }
}
