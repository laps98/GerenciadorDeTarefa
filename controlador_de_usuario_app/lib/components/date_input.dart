import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DateInput extends StatefulWidget {
  final void Function(DateTime?)? onDateChanged;
  final String? initialValue;
  final TextEditingController controller;

  const DateInput({Key? key, this.onDateChanged, this.initialValue, required this.controller}) : super(key: key);

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TextEditingController(text: widget.initialValue ?? '');
  // }
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();
    if (widget.controller.text.isNotEmpty) {
      try {
        initialDate = _dateFormat.parseStrict(widget.controller.text);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      final formatted = _dateFormat.format(picked);
      widget.controller.text = formatted;
      widget.onDateChanged?.call(picked);
    }
  }

  DateTime? _tryParseDate(String input) {
    try {
      return _dateFormat.parseStrict(input);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      inputFormatters: [_maskFormatter],
      decoration: InputDecoration(
        labelText: 'Data',
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: _selectDate,
        ),
        hintText: 'dd/mm/aaaa',
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final date = _tryParseDate(value);
        widget.onDateChanged?.call(date);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione uma data';
        }
        if (_tryParseDate(value) == null) {
          return 'Data inválida (use dd/mm/aaaa)';
        }
        return null;
      },
    );
  }
}
