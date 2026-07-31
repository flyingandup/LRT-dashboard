// lib/widgets/mileage_chart.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

class MileageBarChart extends StatefulWidget {
  final MileageChart data;
  const MileageBarChart({super.key, required this.data});

  @override
  State<MileageBarChart> createState() => _MileageBarChartState();
}

class _MileageBarChartState extends State<MileageBarChart> {
  bool _logScale = false;

  // Log scale helpers — transform real km → log space and back
  double _toLog(double v) => v <= 0 ? 0 : log(v) / ln10;
  double _fromLog(double v) => pow(10, v).toDouble();

  double _barValue(double raw) => _logScale ? _toLog(raw) : raw;

  double _maxY() {
    if (widget.data.values.isEmpty) return _logScale ? 6.0 : 100000;
    final max = widget.data.values.reduce((a, b) => a > b ? a : b).toDouble();
    if (_logScale) {
      return _toLog(max) + 0.3;
    }
    // Snap to next clean interval ceiling, then add 1% padding so fl_chart
    // draws the top gridline without showing an extra label above it
    final interval = _yInterval();
    final ceiling = (max / interval).ceil() * interval;
    return ceiling + (interval * 0.01);
  }

  // Log scale: fixed ticks at 1K, 10K, 100K, 1M
  static const _logTicks = [1000.0, 10000.0, 100000.0, 1000000.0];

  double _yInterval() {
    if (_logScale) return 1.0;
    // Pick a clean interval based on data range so labels never crowd
    if (widget.data.values.isEmpty) return 50000;
    final max = widget.data.values.reduce((a, b) => a > b ? a : b).toDouble();
    if (max > 1000000) return 100000;
    if (max > 500000)  return 100000;
    if (max > 200000)  return 50000;
    return 50000;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Toggle button
        GestureDetector(
          onTap: () => setState(() => _logScale = !_logScale),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _logScale ? AppColors.active.withValues(alpha: 0.15) : AppColors.surface2,
              border: Border.all(color: _logScale ? AppColors.active : AppColors.border),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _logScale ? 'Log Scale' : 'Linear Scale',
              style: GoogleFonts.dmMono(
                fontSize: 11,
                color: _logScale ? AppColors.active : AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Chart
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _maxY(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColors.surface2,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    // always show real km in tooltip regardless of scale
                    final realKm = widget.data.values[groupIndex];
                    return BarTooltipItem(
                      '${widget.data.labels[groupIndex]}\n',
                      GoogleFonts.barlow(color: AppColors.textMain, fontWeight: FontWeight.w600, fontSize: 12),
                      children: [
                        TextSpan(
                          text: '${_fmt(realKm)} km',
                          style: GoogleFonts.dmMono(color: AppColors.muted, fontSize: 11),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 52,
                  interval: _yInterval(),
                  getTitlesWidget: (v, _) {
                    if (v >= _maxY()) return const SizedBox();
                    if (_logScale) {
                      // only label at exact log tick positions (1K, 10K, 100K, 1M)
                      final real = _fromLog(v);
                      final isTickMatch = _logTicks.any((t) => (real - t).abs() < 1);
                      if (!isTickMatch) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          _shortFmt(real.toInt()),
                          style: GoogleFonts.dmMono(fontSize: 10, color: AppColors.muted),
                          textAlign: TextAlign.right,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        _shortFmt(v.toInt()),
                        style: GoogleFonts.dmMono(fontSize: 10, color: AppColors.muted),
                        textAlign: TextAlign.right,
                      ),
                    );
                  },
                )),
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (v, _) {
                    final i = v.toInt();
                    if (i >= widget.data.labels.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(widget.data.labels[i].split(' ').first,
                        style: GoogleFonts.barlow(fontSize: 10, color: AppColors.muted),
                        overflow: TextOverflow.ellipsis),
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
              barGroups: List.generate(widget.data.labels.length, (i) {
                final color = widget.data.statuses[i] == 'active' ? AppColors.active : AppColors.maint;
                return BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: _barValue(widget.data.values[i].toDouble()),
                    color: color.withValues(alpha: 0.75),
                    width: 22,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
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

  // Short format: capital K/M — 50000 → "50K", 1000000 → "1M"
  String _shortFmt(int n) {
    if (n == 0) return '0';
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(n % 1000000 == 0 ? 0 : 1)}M';
    if (n >= 1000) return '${(n / 1000).toInt()}K';
    return '$n';
  }

  // Full format for tooltips: 142300 → "142,300"
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