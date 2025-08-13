import 'package:flutter/material.dart';

class Dropdown<T> extends StatefulWidget {
  final String? label;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value) onChange;
  final bool hasNullOption;
  final T? value;
  final String? Function(T? value)? validator;

  Dropdown({
    super.key,
    this.label,
    required this.items,
    required this.onChange,
    this.value,
    this.validator,
    this.hasNullOption = false,
  });

  @override
  State<Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<Dropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.label!,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          DropdownButtonFormField<T?>(
            isExpanded: true,
            value: widget.value,
            onChanged: widget.onChange, // aceita null
            items: widget.hasNullOption
                ? [
              DropdownMenuItem<T?>(
                value: null,
                child: const Text('Todos'),
              ),
              ...widget.items,
            ]
                : widget.items,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
