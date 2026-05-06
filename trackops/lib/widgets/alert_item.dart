// lib/widgets/alert_item.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

class AlertItem extends StatefulWidget {
  final Alert alert;
  final VoidCallback onDismiss;

  const AlertItem({super.key, required this.alert, required this.onDismiss});

  @override
  State<AlertItem> createState() => _AlertItemState();
}

class _AlertItemState extends State<AlertItem> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.severityColor(widget.alert.severity);
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Severity accent bar on the left
            Container(width: 3, color: color, margin: const EdgeInsets.symmetric(vertical: 4)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: severity + train ID + time + bin
                    Row(
                      children: [
                        Text(widget.alert.severity.toUpperCase(),
                          style: GoogleFonts.dmMono(fontSize: 10, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.8)),
                        const SizedBox(width: 8),
                        Text(widget.alert.train,
                          style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
                        const Spacer(),
                        if (!_confirming) ...[
                          Text(widget.alert.time,
                            style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
                          const SizedBox(width: 8),
                          // Bin button
                          Tooltip(
                            message: 'Dismiss alert',
                            child: InkWell(
                              onTap: () => setState(() => _confirming = true),
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Icon(Icons.delete_outline, size: 15, color: AppColors.muted),
                              ),
                            ),
                          ),
                        ],
                        // Confirm state
                        if (_confirming) ...[
                          Text('Remove?',
                            style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: widget.onDismiss,
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.critical.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.critical.withValues(alpha: 0.3)),
                              ),
                              child: Text('Remove',
                                style: GoogleFonts.dmMono(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.critical)),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () => setState(() => _confirming = false),
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surface2,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text('Cancel',
                                style: GoogleFonts.dmMono(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.muted)),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Milestone pills
                    ...widget.alert.milestones.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: color.withValues(alpha: 0.2)),
                        ),
                        child: Text(m,
                          style: GoogleFonts.dmMono(fontSize: 10, fontWeight: FontWeight.w500, color: color)),
                      ),
                    )),

                    const SizedBox(height: 4),

                    // Main message
                    Text(widget.alert.message,
                      style: GoogleFonts.barlow(fontSize: 13, color: AppColors.textMain, height: 1.4)),

                    // Detail lines — only show if 2+ milestones
                    if (widget.alert.details.length > 1) ...[
                      const SizedBox(height: 6),
                      ...widget.alert.details.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text('• $d',
                          style: GoogleFonts.barlow(fontSize: 12, color: AppColors.muted, height: 1.4)),
                      )),
                    ],
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