import 'package:controlador_de_usuario_app/models/enums/statas_da_tarefa.dart';
import 'package:controlador_de_usuario_app/models/filters/query_filter.dart';
import 'package:controlador_de_usuario_app/models/tarefa_request.dart';
import 'package:controlador_de_usuario_app/models/tarefa_response.dart';
import 'package:controlador_de_usuario_app/services/base_service.dart';

class TarefaService extends BaseService {
  final String _controllerName = 'Tarefa';

  Future<List<TarefaResponse>> listar({
    required int page,
    String? titulo,
    DateTime? dataDaTarefa,
    StatusDaTarefa? status,
  }) async {
    var filters = QueryFilter(
      predicate: 'Data',
      reverse: true,
      search: '',
      currentPage: (page / 10).round() + 1,
      itemsPerPage: 10,
    ).toJson();
    filters['titulo'] = titulo;
    filters['dataDaTarefa'] = dataDaTarefa?.toIso8601String();
    filters['status'] = status?.index.toString();

    var response = await list('$_controllerName/Listar', queryParameters: filters);
    List<TarefaResponse> tarefas = response.map((q) => TarefaResponse.fromJson(q)).toList();

    return tarefas;
  }

  Future<void> salvar({required TarefaRequest request}) async {
    var jsonRequest = request.toJson();
    await post('$_controllerName/Save', jsonRequest);
  }

  Future<void> excluir(int id) async {
    await delete('$_controllerName/Excluir/$id');
  }
}
