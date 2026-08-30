import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class DistanceMatrixTable extends StatelessWidget {
  final List<Map<String, dynamic>> stations;
  final List<Map<String, dynamic>> distances;

  const DistanceMatrixTable({
    super.key,
    required this.distances,
    required this.stations,
  });

  double? findDistance(String id1, String id2) {
    if (id1 == id2) return 0.0;
    for (final d in distances) {
      final fId = d["firstStationId"];
      final sId = d["secondStationId"];

      if ((fId == id1) && (sId == id2) || (sId == id1) && (fId == id2)) {
        return (d['distance'] as num?)?.toDouble();
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return const SizedBox.shrink();
    }

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(110),
              border: TableBorder.all(color: AppColors.border, width: 0.5),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: AppColors.surface2),
                  children: [
                    _buildHeaderCell('From/To'),
                    ...stations
                        .map((s) => _buildHeaderCell(s['name'] as String))
                  ],
                ),
                ...stations.map(
                  (rowStation) {
                    return TableRow(
                      children: [
                        _buildHeaderCell(rowStation['name'] as String),
                        ...stations.map(
                          (colStation) {
                            final isSelf = rowStation['id'] == colStation['id'];
                            final dist = findDistance(
                                rowStation['id'] as String,
                                colStation['id'] as String);

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              color: isSelf
                                  ? AppColors.surface2.withValues(alpha : 0.5)
                                  : AppColors.surface,
                              child: Text(
                                isSelf ? '-' : (dist != null ? '$dist' : '-'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmMono(
                                  fontSize: 12,
                                  color: isSelf
                                      ? AppColors.muted
                                      : AppColors.textMain,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      color: AppColors.surface2,
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.barlow(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}
