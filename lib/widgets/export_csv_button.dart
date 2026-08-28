import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackops/services/csv_service.dart';
import 'package:trackops/theme.dart';

class ExportCsvButton extends StatelessWidget {
  final List<Map<String, dynamic>> distances;
  const ExportCsvButton({
    super.key,
    required this.distances,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.maint,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () async {
        try {
          await encodeDistancesToCsvFile(distances);
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error Exporting Distances: $e'),
              backgroundColor: AppColors.accent,
            ),
          );
        }
      },
      label: Text('Export CSV',
          style: GoogleFonts.barlow(
              color: Colors.white, fontWeight: FontWeight.w500, height: 0)),
      icon: const Icon(
        Icons.file_upload,
        color: Colors.white,
      ),
    );
  }
}
