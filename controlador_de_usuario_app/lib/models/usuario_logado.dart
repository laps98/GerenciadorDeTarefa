import 'dart:convert';

import 'package:controlador_de_usuario_app/main.dart';
import 'package:controlador_de_usuario_app/screens/login_page.dart';
import 'package:controlador_de_usuario_app/services/conta_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ContaService _contaService = ContaService();

class UsuarioLogado {
  final int id;
  final String nome;
  final String email;
  final String administrador;

  UsuarioLogado({
    required this.id,
    required this.nome,
    required this.email,
    required this.administrador,
  });

  factory UsuarioLogado.fromJson(Map<String, dynamic> map) {
    return UsuarioLogado(
      id: map['Id'],
      nome: map['Nome'],
      email: map['Email'],
      administrador: map['Administrador'],
    );
  }

  static Future<void> set(Map<String, dynamic> data) async {
    var prefs = await SharedPreferences.getInstance();

    var jsonData = json.encode(data);

    await prefs.setString('UsuarioLogado', jsonData);
  }

  static Future<UsuarioLogado?> get() async {
    var prefs = await SharedPreferences.getInstance();
    var dataDeExpiracaoFormatada = prefs.getString('DataDeExpiracao');
    if (dataDeExpiracaoFormatada == null) {
      await _contaService.sair();
      return null;
    }

    var dataDeExpiracao = DateFormat('yyyy-MM-dd HH:mm').parse(dataDeExpiracaoFormatada);

    final dataAtual = DateTime.now();
    if (dataAtual.isAfter(dataDeExpiracao)) {
      await _contaService.sair();
      await MyApp.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      return null;
    }

    var response = prefs.getString('UsuarioLogado');
    if (response == null) {
      return null;
    }

    final data = json.decode(response);

    return UsuarioLogado.fromJson(data);
  }
}