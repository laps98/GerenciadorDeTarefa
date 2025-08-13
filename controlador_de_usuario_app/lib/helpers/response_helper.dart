import 'dart:convert';

import 'package:controlador_de_usuario_app/main.dart';
import 'package:controlador_de_usuario_app/screens/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

extension ResponseHelper on DioException {
  Future<String> handleError() async {
    final data = response?.data;

    if (response != null && response?.statusCode == 401) {
      await MyApp.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      return "";
    }

    if (data != null) {
      dynamic jsonData;

      if (data is String) {
        jsonData = json.decode(data);
      } else if (data is Map<String, dynamic>) {
        jsonData = data;
      }

      if (jsonData != null && jsonData is Map<String, dynamic> && jsonData.containsKey('Message')) {
        String message = jsonData['Message'];
        return message;
      }

      if (jsonData != null && jsonData is Map<String, dynamic> && jsonData.containsKey('errors')) {
        String message = jsonData['errors'];
        return message;
      }
    }

    throw DioException(
      requestOptions: requestOptions,
    );
  }

  Future<String> get errorApi async {
    final data = response?.data;

    if (response != null && response?.statusCode == 401) {
      await MyApp.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      return "";
    }

    if (data != null) {
      dynamic jsonData;

      if (data is String) {
        try {
          jsonData = json.decode(data);
        } catch (_) {
          return data;
        }
      } else if (data is Map<String, dynamic>) {
        jsonData = data;
      }

      if (jsonData is Map<String, dynamic> && jsonData.containsKey('Message')) {
        return jsonData['Message'] ?? 'Erro desconhecido';
      }
    }

    return message ?? 'Erro desconhecido';
  }
}