import 'package:flutter/material.dart';

class InputDecorations {
  static Color primary = Colors.deepPurple;

  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primary)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primary, width: 2)),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: primary) : null
    );
  }
}