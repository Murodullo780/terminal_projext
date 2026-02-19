import 'package:flutter/material.dart';
import 'dart:math';

class AppColors {
  static const Color primary = Color(0xFFF05039);

  static final List<Color> prodColors = [
    const Color(0xFF4ECDC4), // turquoise
    const Color(0xFFFF6B6B), // coral
    const Color(0xFF45B7D1), // sky blue
    const Color(0xFFF7B731), // yellow
    const Color(0xFF9B59B6), // amethyst
    const Color(0xFF2ECC71), // emerald
    const Color(0xFFE74C3C), // alizarin
    const Color(0xFF3498DB), // peter river
    const Color(0xFFF1C40F), // sunflower
    const Color(0xFF1ABC9C), // nephritis
    const Color(0xFFE67E22), // carrot
    const Color(0xFF34495E), // wet asphalt
    const Color(0xFF27AE60), // nephrite green
    const Color(0xFF8E44AD), // wisteria
    const Color(0xFFD35400), // pumpkin
  ];

  // ───────────────────────────────────────────────
  // If you want completely random colors every app start:
  // ───────────────────────────────────────────────
  static List<Color> get randomProdColors {
    final random = Random();
    return List.generate(15, (_) {
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  // Or slightly nicer random colors (avoid too dark / too pale):
  static List<Color> get niceRandomProdColors {
    final random = Random();
    return List.generate(15, (_) {
      return Color.fromARGB(
        255,
        60 + random.nextInt(196), // 60–255   → avoids very dark
        40 + random.nextInt(216), // 40–255
        50 + random.nextInt(206),
      );
    });
  }
}
