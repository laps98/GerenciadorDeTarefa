import 'package:flutter/material.dart';

enum StatusDaTarefa { pendente, concluida, cancelada }

extension StatasDaTarefaExtension on StatusDaTarefa {
  String dislpayName() {
    switch (this) {
      case StatusDaTarefa.pendente:
        return 'Pendente';
      case StatusDaTarefa.concluida:
        return 'Concluda';
      case StatusDaTarefa.cancelada:
        return 'Cancelada';
      default:
        return 'Erro ao buscar status';
    }
  }
}

extension StatasDaTarefaDropdown on StatusDaTarefa {
  DropdownMenuItem<StatusDaTarefa> get toDropdownItem {
    return DropdownMenuItem(
      value: this,
      child: Text(dislpayName()),
    );
  }
}