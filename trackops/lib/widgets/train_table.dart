// lib/widgets/train_table.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

class TrainTable extends StatelessWidget {
  final List<Train> trains;
  const TrainTable({super.key, required this.trains});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          ...trains.asMap().entries.map((e) => _buildRow(e.value, e.key)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        _hCell('Train ID', flex: 2),
        _hCell('Name', flex: 3),
        _hCell('Route', flex: 3),
        _hCell('Status', flex: 2),
        _hCell('Mileage (km)', flex: 2),
        _hCell('Last Service', flex: 2),
      ]),
    );
  }

  Widget _hCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Text(text.toUpperCase(),
          style: GoogleFonts.barlow(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted, letterSpacing: 0.7)),
      ),
    );
  }

  Widget _buildRow(Train t, int index) {
    final statusColor = t.isActive ? AppColors.active : AppColors.maint;
    return Container(
      color: index.isEven ? AppColors.surface : AppColors.surface2,
      child: Row(children: [
        Expanded(flex: 2, child: _cell(
          Text(t.id, style: GoogleFonts.dmMono(fontSize: 12, color: AppColors.muted)))),
        Expanded(flex: 3, child: _cell(
          Text(t.name, style: GoogleFonts.barlow(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMain)))),
        Expanded(flex: 3, child: _cell(
          Text(t.route, style: GoogleFonts.barlow(fontSize: 13, color: AppColors.muted)))),
        Expanded(flex: 2, child: _cell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text(t.isActive ? 'Active' : 'Maintenance',
                style: GoogleFonts.dmMono(fontSize: 11, fontWeight: FontWeight.w500, color: statusColor)),
            ]),
          ),
        )),
        Expanded(flex: 2, child: _cell(
          Text(_fmt(t.mileage), style: GoogleFonts.dmMono(fontSize: 13, color: AppColors.textMain)))),
        Expanded(flex: 2, child: _cell(
          Text(t.lastService, style: GoogleFonts.dmMono(fontSize: 12, color: AppColors.muted)))),
      ]),
    );
  }

  Widget _cell(Widget child) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13), child: child);
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
