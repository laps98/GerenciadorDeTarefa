import 'dart:io';

import 'package:controlador_de_usuario_app/components/date_input.dart';
import 'package:controlador_de_usuario_app/helpers/future_helper.dart';
import 'package:controlador_de_usuario_app/models/tarefa_request.dart';
import 'package:controlador_de_usuario_app/models/tarefa_response.dart';
import 'package:controlador_de_usuario_app/services/tarefa_sevice.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TaskRegisterPage extends StatefulWidget {
  TarefaResponse? response;

  TaskRegisterPage({this.response, super.key});

  @override
  State<TaskRegisterPage> createState() => _TaskRegisterPageState();
}

class _TaskRegisterPageState extends State<TaskRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TarefaRequest _request = TarefaRequest();
  final ImagePicker _picker = ImagePicker();
  final _service = TarefaService();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    setState(() {
      _request.imagens.addAll(images.map((xFile) => ImagemAnexo(file: File(xFile.path))));
    });
  }

  @override
  void initState() {
    if(widget.response != null) {
      _request = TarefaRequest.fromResponse(widget.response!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefa'),
        actions: [
          if(_request.id!=null)
          IconButton(
            icon: const Icon(Icons.recycling),
            onPressed: () {
              _service.excluir(_request.id!).whenComplete(() => Navigator.pop(context)).handleError(context);
            },
          ),
        ],),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _service.salvar(request: _request).whenComplete(() => Navigator.pop(context)).handleError(context);
            }
          },
          child: const Text('Salvar'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _request.titulo,
                  decoration: const InputDecoration(labelText: 'Título'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _request.descricao,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DateInput(
                  controller: _request.dataDaTarefa,
                  onDateChanged: (date) {
                    // salva data
                  },
                ),
                const SizedBox(height: 16.0),

                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Selecione as imagens'),
                ),
                const SizedBox(height: 20),
                // Display selected images in a GridView
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _request.imagens.length,
                  itemBuilder: (context, index) {
                    final imagem = _request.imagens[index];

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: imagem.caminho != null && imagem.caminho!.isNotEmpty
                              ? Image.network(
                                  imagem.caminho!,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  imagem.file!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _request.imagens.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
