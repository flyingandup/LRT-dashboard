// lib/widgets/alert_item.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

class AlertItem extends StatelessWidget {
  final Alert alert;
  const AlertItem({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.severityColor(alert.severity);
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: color, margin: const EdgeInsets.symmetric(vertical: 4)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(alert.severity.toUpperCase(),
                        style: GoogleFonts.dmMono(fontSize: 10, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.8)),
                      const SizedBox(width: 8),
                      Text(alert.train,
                        style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
                    ]),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Text('${alert.cycle}  —  ${alert.label}',
                        style: GoogleFonts.dmMono(fontSize: 10, fontWeight: FontWeight.w500, color: color)),
                    ),
                    const SizedBox(height: 5),
                    Text(alert.message,
                      style: GoogleFonts.barlow(fontSize: 13, color: AppColors.textMain, height: 1.4)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
