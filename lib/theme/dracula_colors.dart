import 'package:flutter/material.dart';

// Dracula Theme Farben
class DraculaColors {
  static const background = Color(0xFF282A36);
  static const white = Color(0xFFF8F8F2);
  static const cyan = Color(0xFF8BE9FD);    // Klassen
  static const green = Color(0xFF50FA7B);   // Methoden
  static const purple = Color(0xFFBD93F9);  // Keywords (var, final, etc.)
}

// TextStyles für Syntax-Highlighting
class DraculaStyles {
  static const _base = TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.5);

  static final keyword = _base.copyWith(color: DraculaColors.purple);
  static final className = _base.copyWith(color: DraculaColors.cyan);
  static final method = _base.copyWith(color: DraculaColors.green);
  static final normal = _base.copyWith(color: DraculaColors.white);
}