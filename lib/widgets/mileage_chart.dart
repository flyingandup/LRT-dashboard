// lib/widgets/mileage_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

class MileageBarChart extends StatelessWidget {
  final List<Train> trains;
  final String title;

  const MileageBarChart({super.key, required this.trains, required this.title});

  @override
  Widget build(BuildContext context) {
    if (trains.isEmpty) {
      return Center(child: Text('No data', style: GoogleFonts.barlow(color: AppColors.muted)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart title
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title.toUpperCase(),
            style: GoogleFonts.barlowCondensed(fontSize: 11, fontWeight: FontWeight.w700,
              letterSpacing: 0.8, color: AppColors.muted)),
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _maxY(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColors.surface2,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${trains[groupIndex].name}\n',
                      GoogleFonts.barlow(color: AppColors.textMain, fontWeight: FontWeight.w600, fontSize: 12),
                      children: [TextSpan(
                        text: '${_fullFmt(rod.toY.toInt())} km',
                        style: GoogleFonts.dmMono(color: AppColors.muted, fontSize: 11),
                      )],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 48,
                  getTitlesWidget: (v, meta) {
                    if (v == meta.min || v == meta.max) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(_shortFmt(v.toInt()),
                        style: GoogleFonts.dmMono(fontSize: 9, color: AppColors.muted),
                        textAlign: TextAlign.right),
                    );
                  },
                )),
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    if (i >= trains.length) return const SizedBox();
                    // Show short ID like "BP-001" → "001"
                    final id = trains[i].id;
                    final short = id.contains('-') ? id.split('-').last : id;
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(short,
                        style: GoogleFonts.dmMono(fontSize: 9, color: AppColors.muted)),
                    );
                  },
                )),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(trains.length, (i) {
                final color = trains[i].isActive ? AppColors.active : AppColors.maint;
                return BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: trains[i].mileage.toDouble(),
                    color: color.withOpacity(0.75),
                    width: 14,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    borderSide: BorderSide(color: color, width: 1),
                  ),
                ]);
              }),
            ),
          ),
        ),
      ],
    );
  }

  double _maxY() {
    if (trains.isEmpty) return 100000;
    return (trains.map((t) => t.mileage).reduce((a, b) => a > b ? a : b) * 1.15).ceilToDouble();
  }

  String _shortFmt(int n) {
    if (n <= 0) return '0';
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toInt()}k';
    return '$n';
  }

  String _fullFmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
