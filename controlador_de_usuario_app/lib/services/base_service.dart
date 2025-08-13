import 'dart:io';

import 'package:controlador_de_usuario_app/helpers/response_helper.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlService = Platform.isAndroid ? '10.0.2.2:5013' : '127.0.0.1:5013';
final dio = Dio(
  BaseOptions(
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 60),
  sendTimeout: const Duration(seconds: 60),
),);

class BaseService {
  static Uri getUri(String url, [Map<String, dynamic>? queryParameters]) {
    //if (kDebugMode) {
      return Uri.http(urlService, url, queryParameters);
    //}
    //return Uri.https(urlService, url, queryParameters);
  }

  Future<Options> _options() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';

    var headers = {
      'authorization': 'Bearer $token',
      Headers.contentTypeHeader: 'application/json',
    };

    return Options(

      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: headers,
    );
  }
  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      var uri = getUri(url, queryParameters);

      var response = await dio.getUri(uri, options: await _options());

      Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return data;
    } on DioException catch (e) {
      throw await e.errorApi;
    }
  }

  Future<List> list(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      var uri = getUri(url, queryParameters);

      final response = await dio.getUri(uri, options: await _options());
      if (response.data == "") {
        return [];
      }

      return response.data;
    } on DioException catch (e) {
      throw await e.errorApi;
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    var uri = getUri(url);
    try {

      var response = await dio.postUri(uri, data: body, options: await _options());

      return response.data;
    } on DioException catch (e) {
      throw await e.errorApi;
    }
  }

  Future<dynamic> put(String url,
      {Map<String, dynamic> body = const {}}) async {
    var uri = getUri(url);
    try {
      var response =
          await dio.putUri(uri, data: body, options: await _options());
      return response.data;
    } on DioException catch (e) {
      throw await e.errorApi;
    }
  }

  Future<dynamic> delete(String url, {Map<String, dynamic>? body}) async {
    var uri = getUri(url);
    try {
      var response =
          await dio.deleteUri(uri, data: body, options: await _options());
      return response.data;
    } on DioException catch (e) {
      throw await e.errorApi;
    }
  }
}
