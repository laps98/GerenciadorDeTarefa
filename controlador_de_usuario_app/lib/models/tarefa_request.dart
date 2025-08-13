import 'dart:convert';
import 'dart:io';
import 'package:controlador_de_usuario_app/models/tarefa_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TarefaRequest {
  int? id;
  TextEditingController titulo = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController dataDaTarefa = TextEditingController();
  List<ImagemAnexo> imagens = [];
  
  TarefaRequest();
  
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> imagensToJson = [];

    if (imagens.isNotEmpty) {
      for (var file in imagens) {
        imagensToJson.add({
          'id': file.id,
          'base64': file.file!=null?base64Encode(file.file!.readAsBytesSync()):null,
          'extensao': file.file?.path.split('.').last,
          'caminho': file.caminho
        });
      }
    }

    DateTime? dataFormatada;
    try {
      dataFormatada = DateFormat('dd/MM/yyyy').parse(dataDaTarefa.text);
    } catch (e) {
      dataFormatada = null;
    }

    return {
      'id': id,
      'titulo': titulo.text,
      'descricao': descricao.text,
      'dataDaTarefa': dataFormatada?.toIso8601String() ?? '',
      'imagens': imagensToJson,
    };
  }

  factory TarefaRequest.fromResponse(TarefaResponse response) {
    var request = TarefaRequest();
    request.id = response.id;
    request.titulo.text = response.titulo;
    request.descricao.text = response.descricao;

    request.dataDaTarefa.text = response.dataDaTarefa;

    if (response.imagens != null) {
      request.imagens = response.imagens!
          .map((img) => ImagemAnexo(id: img.id,caminho: img.caminho))
          .toList();
    }

    return request;
  }
}

class ImagemAnexo {
  int? id;
  File? file;
  String? caminho;
  ImagemAnexo({this.id, this.file, this.caminho});
}