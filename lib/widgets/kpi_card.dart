// lib/widgets/kpi_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color accentColor;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.sub,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(),
                  style: GoogleFonts.barlow(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted, letterSpacing: 0.8)),
                const SizedBox(height: 8),
                Text(value,
                  style: GoogleFonts.barlowCondensed(fontSize: 38, fontWeight: FontWeight.w700, color: accentColor, height: 1)),
                const SizedBox(height: 6),
                Text(sub,
                  style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
