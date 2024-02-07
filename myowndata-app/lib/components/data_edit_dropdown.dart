import 'package:flutter/material.dart';

class DataEditDropdown extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;

  DataEditDropdown({required this.items, required this.controller});

  @override
  _DataEditDropdownState createState() => _DataEditDropdownState();
}

class _DataEditDropdownState extends State<DataEditDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.controller.text,
      onChanged: (String? newValue) {
        setState(() {
          widget.controller.text = newValue ?? '';
        });
      },
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}
