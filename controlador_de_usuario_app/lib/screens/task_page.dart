import 'package:controlador_de_usuario_app/components/dropdown.dart';
import 'package:controlador_de_usuario_app/models/enums/statas_da_tarefa.dart';
import 'package:controlador_de_usuario_app/models/tarefa_response.dart';
import 'package:controlador_de_usuario_app/screens/task_register_page.dart';
import 'package:controlador_de_usuario_app/services/tarefa_sevice.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TarefaService _service = TarefaService();

  final PagingController<int, TarefaResponse> _pagingController = PagingController(firstPageKey: 0);

  String? _filterTitulo;
  DateTime? _filterData;
  StatusDaTarefa? _status;

  final TextEditingController _tituloController = TextEditingController();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int page) async {
    try {
      final newItems = await _service.listar(
        page: page,
        titulo: _filterTitulo,
        dataDaTarefa: _filterData,
        status: _status
      );
      final isLastPage = newItems.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = page + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _applyFilters() {
    _filterTitulo = _tituloController.text.trim().isEmpty ? null : _tituloController.text.trim();
    _pagingController.refresh();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterData ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _filterData = picked;
      });
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TaskRegisterPage()))
              .whenComplete(() => _pagingController.refresh());
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // FILTROS
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Campo título
                  Expanded(
                    child: TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        labelText: 'Filtrar por título',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _tituloController.clear();
                            _applyFilters();
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _applyFilters(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Botão data
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.date_range),
                    label: Text(_filterData == null
                        ? 'Filtrar por data'
                        : "${_filterData!.day}/${_filterData!.month}/${_filterData!.year}"),
                  ),

                  if (_filterData != null)
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _filterData = null;
                        });
                        _pagingController.refresh();
                      },
                    ),
                ],
              ),
            ),

      Dropdown<StatusDaTarefa>(
        label: 'Status',
        value: _status,
        hasNullOption: true,
        items: StatusDaTarefa.values.map((e) => e.toDropdownItem).toList(),
        onChange: (StatusDaTarefa? value) {
          setState(() {
            _status = value;
          });
          _pagingController.refresh();
        },
      ),

            // LISTAGEM
            Expanded(
              child: PagedListView<int, TarefaResponse>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<TarefaResponse>(
                  itemBuilder: (context, item, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => TaskRegisterPage(response: item)))
                          .whenComplete(() => _pagingController.refresh()),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        shadowColor: Colors.grey.withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item.titulo,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    item.dataDaTarefa,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.descricao,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) => const Center(child: Text('Serviço indisponível')),
                  firstPageProgressIndicatorBuilder: (context) => const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder: (context) => const Center(child: CircularProgressIndicator()),
                  noItemsFoundIndicatorBuilder: (context) => const Center(child: Text('Nenhuma tarefa encontrada')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
