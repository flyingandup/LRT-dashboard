import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackops/services/csv_service.dart';
import 'package:trackops/theme.dart';

class importCsvButton extends StatelessWidget {
  final ValueChanged<List<List<dynamic>>> onValueSelected;
  const importCsvButton({
    super.key,
    required this.onValueSelected,
  });

  Future<void> pickCsvFile() async {
    PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (file != null) {
      final bytes = await file.readAsBytes();
      String csvString = utf8.decode(bytes);
      List<List<dynamic>> parsedData = convertFromCsv(csvString);
      onValueSelected(parsedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.active,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () {
        pickCsvFile();
      },
      label: Text('Import CSV',
          style: GoogleFonts.barlow(
              color: Colors.white, fontWeight: FontWeight.w500, height: 0)),
      icon: const Icon(
        Icons.file_upload,
        color: Colors.white,
      ),
    );
  }
}
