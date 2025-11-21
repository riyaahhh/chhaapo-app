import 'package:flutter/material.dart';
Widget enumDropdown<T>({
  required String label,
  required T? value,
  required List<T> values,
  required ValueChanged<T?> onChanged,
}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: values
            .map((e) => DropdownMenuItem(value: e, child: Text("${e}".split('.').last)))
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );
