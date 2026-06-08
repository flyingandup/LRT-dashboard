// lib/widgets/grouped_alert_item.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/milestone_service.dart';
import '../theme.dart';

class GroupedAlertItem extends StatelessWidget {
  final GroupedAlert alert;
  const GroupedAlertItem({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final topColor = AppColors.severityColor(alert.severity);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left severity bar
          Container(
            width: 3,
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            color: topColor,
          ),
          // Content — use Flexible to prevent overflow
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Train header row
                  Row(children: [
                    Text(alert.trainId,
                      style: GoogleFonts.dmMono(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(alert.trainName,
                        style: GoogleFonts.barlow(fontSize: 13, color: AppColors.muted),
                        overflow: TextOverflow.ellipsis),
                    ),
                    if (alert.entries.length > 1) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: topColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: topColor.withOpacity(0.3)),
                        ),
                        child: Text('${alert.entries.length} items',
                          style: GoogleFonts.dmMono(fontSize: 10, color: topColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 8),
                  // Milestone entries
                  ...alert.entries.map((e) => _buildEntry(e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(MilestoneEntry e) {
    final color   = AppColors.severityColor(e.severity);
    final kmText  = e.kmRemaining == 0 ? 'Due now' : 'in ${_fmt(e.kmRemaining)} km';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(width: 7, height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Text('${e.cycle}  —  ${e.label}',
                        style: GoogleFonts.dmMono(fontSize: 10, fontWeight: FontWeight.w500, color: color)),
                    ),
                    Text(kmText,
                      style: GoogleFonts.dmMono(fontSize: 10, color: AppColors.muted)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(e.detail,
                  style: GoogleFonts.barlow(fontSize: 12, color: AppColors.muted, height: 1.3),
                  softWrap: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
