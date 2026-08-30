// lib/widgets/train_table.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class DistanceTable extends StatelessWidget {
  final List<Map<String, dynamic>> distances;
  const DistanceTable({
    super.key,
    required this.distances,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(children: [
        _buildHeader(),
        ...distances.asMap().entries.map((e) => _buildRow(e.value, e.key)),
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        _hCell('First Station', flex: 2),
        _hCell('Second Station', flex: 2),
        _hCell('Distance (KM)', flex: 2)
      ]),
    );
  }

  Widget _hCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Text(text.toUpperCase(),
            style: GoogleFonts.barlow(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
                letterSpacing: 0.7)),
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> distance, int index) {
    bool isHovered = false;
    return StatefulBuilder(builder: (context, setState) {
      return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          color: isHovered
              ? AppColors.surface2.withValues(alpha: 0.7)
              : index.isEven
                  ? AppColors.surface
                  : AppColors.surface2,
          child: Row(children: [
            Expanded(
                flex: 1,
                child: _cell(Text(distance["firstStationName"],
                    style: GoogleFonts.dmMono(
                        fontSize: 12, color: AppColors.muted)))),
            Expanded(
                flex: 1,
                child: _cell(Text(distance["secondStationName"],
                    style: GoogleFonts.dmMono(
                        fontSize: 12, color: AppColors.muted)))),
            Expanded(
                flex: 1,
                child: _cell(Text(distance["distance"].toString(),
                    style: GoogleFonts.dmMono(
                        fontSize: 13, color: AppColors.textMain)))),
          ]),
        ),
      );
    });
  }

  Widget _cell(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: child);
}
