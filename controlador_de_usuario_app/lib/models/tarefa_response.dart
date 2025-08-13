import 'package:controlador_de_usuario_app/models/enums/statas_da_tarefa.dart';

class TarefaResponse {
  final int id;
  final String titulo;
  final String descricao;
  final String dataDaTarefa; //formato dd/MM/yyyy HH:mm
  final StatusDaTarefa status; //formato dd/MM/yyyy HH:mm
  List<Imagem>? imagens = [];

  TarefaResponse({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataDaTarefa,
    required this.status,
    this.imagens
  });

  factory TarefaResponse.fromJson(Map<String, dynamic> map) {
    var imagens = map['Imagens'] as List;

    return TarefaResponse(
      id: map['Id'],
      titulo: map['Titulo'],
      descricao: map['Descricao'],
      dataDaTarefa: map['DataDaTarefa'],
      status: StatusDaTarefa.values[map['Status']],
      imagens: imagens.map((e) => Imagem.fromJson(e)).toList()
    );
  }
}

class Imagem{
  final int id;
  final String caminho;

  Imagem({required this.caminho, required this.id});

  factory Imagem.fromJson(dynamic map){
    return Imagem(id:map['Id'],caminho: map['Caminho']);
  }
}
