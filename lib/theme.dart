// lib/theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const bg       = Color(0xFFF4F6FA);
  static const surface  = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFEEF1F7);
  static const border   = Color(0xFFE2E6EF);
  static const border2  = Color(0xFFCDD3E0);
  static const textMain = Color(0xFF1A1D27);
  static const muted    = Color(0xFF7B8199);
  static const accent   = Color(0xFF2D7EF0);
  static const active   = Color(0xFF16A660);
  static const maint    = Color(0xFFE07B10);
  static const critical = Color(0xFFD03030);
  static const warning  = Color(0xFFE07B10);
  static const info     = Color(0xFF2D7EF0);

  static Color severityColor(String severity) {
    switch (severity) {
      case 'critical': return critical;
      case 'warning':  return warning;
      default:         return info;
    }
  }
}
