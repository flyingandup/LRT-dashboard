// lib/screens/dashboard_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../widgets/kpi_card.dart';
import '../widgets/alert_item.dart';
import '../widgets/train_table.dart';
import '../widgets/mileage_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Summary? _summary;
  List<Train> _trains = [];
  List<Alert> _alerts = [];
  MileageChart? _chartData;
  bool _loading = true;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _loadAll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadAll() async {
    try {
      final results = await Future.wait([
        ApiService.fetchSummary(),
        ApiService.fetchTrains(),
        ApiService.fetchAlerts(),
        ApiService.fetchMileageChart(),
      ]);
      setState(() {
        _summary   = results[0] as Summary;
        _trains    = results[1] as List<Train>;
        _alerts    = results[2] as List<Alert>;
        _chartData = results[3] as MileageChart;
        _loading   = false;
        _error     = null;
      });
    } catch (e) {
      setState(() {
        _error   = 'Cannot connect to server. Is FastAPI running on localhost:8000?';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(children: [
        _buildHeader(),
        Expanded(child: _loading
            ? _buildLoading()
            : _error != null
                ? _buildError()
                : _buildDashboard()),
      ]),
    );
  }

  // ---- HEADER ----
  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
          child: const Icon(Icons.train, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        RichText(text: TextSpan(
          style: GoogleFonts.barlowCondensed(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textMain, letterSpacing: 1),
          children: [
            const TextSpan(text: 'Track'),
            TextSpan(text: 'Ops', style: const TextStyle(color: AppColors.accent)),
          ],
        )),
        const Spacer(),
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.active, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('LIVE', style: GoogleFonts.dmMono(fontSize: 12, color: AppColors.active)),
        const SizedBox(width: 20),
        if (_summary != null)
          Text('Updated: ${_summary!.timestamp}', style: GoogleFonts.dmMono(fontSize: 12, color: AppColors.muted)),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.muted, size: 18),
          onPressed: _loadAll,
          tooltip: 'Refresh',
        ),
      ]),
    );
  }

  // ---- LOADING / ERROR ----
  Widget _buildLoading() => const Center(child: CircularProgressIndicator(color: AppColors.accent));

  Widget _buildError() {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.wifi_off, color: AppColors.critical, size: 48),
      const SizedBox(height: 16),
      Text(_error!, style: GoogleFonts.barlow(color: AppColors.muted, fontSize: 15)),
      const SizedBox(height: 16),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
        onPressed: _loadAll,
        child: Text('Retry', style: GoogleFonts.barlow(color: Colors.white)),
      ),
    ]));
  }

  // ---- MAIN DASHBOARD ----
  Widget _buildDashboard() {
    final s         = _summary!;
    final activePct = s.totalTrains > 0 ? (s.active / s.totalTrains * 100).round() : 0;
    final maintPct  = s.totalTrains > 0 ? (s.maintenance / s.totalTrains * 100).round() : 0;
    final hasCrit   = (s.alertCounts['critical'] ?? 0) > 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ---- KPI CARDS (no avg mileage) ----
        _sectionLabel('Fleet Overview'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: KpiCard(label: 'Total Trains',   value: '${s.totalTrains}', sub: 'Fleet size',           accentColor: AppColors.accent)),
          const SizedBox(width: 16),
          Expanded(child: KpiCard(label: 'Active',         value: '${s.active}',      sub: '$activePct% in service', accentColor: AppColors.active)),
          const SizedBox(width: 16),
          Expanded(child: KpiCard(label: 'In Maintenance', value: '${s.maintenance}', sub: '$maintPct% of fleet',  accentColor: AppColors.maint)),
          const SizedBox(width: 16),
          Expanded(child: KpiCard(
            label: 'Active Alerts',
            value: '${s.totalAlerts}',
            sub: '${s.alertCounts['critical'] ?? 0} critical',
            accentColor: s.totalAlerts == 0 ? AppColors.active : hasCrit ? AppColors.critical : AppColors.warning,
          )),
        ]),
        const SizedBox(height: 24),

        // ---- CHART + ALERTS ----
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Mileage chart
            Expanded(child: _panel(
              title: 'Mileage per Train',
              child: SizedBox(
                height: 280,
                child: _chartData != null
                    ? MileageBarChart(data: _chartData!)
                    : const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              ),
            )),
            const SizedBox(width: 20),

            // PM Alerts panel
            SizedBox(width: 360, child: _panel(
              title: 'PM Milestone Alerts',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  _alertMini('Critical', s.alertCounts['critical'] ?? 0, AppColors.critical),
                  const SizedBox(width: 8),
                  _alertMini('Warning',  s.alertCounts['warning']  ?? 0, AppColors.warning),
                  const SizedBox(width: 8),
                  _alertMini('Info',     s.alertCounts['info']     ?? 0, AppColors.info),
                ]),
                const SizedBox(height: 12),
                Divider(color: AppColors.border, height: 1),
                if (_alerts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text('No alerts — all trains on track.',
                      style: GoogleFonts.barlow(fontSize: 13, color: AppColors.muted))),
                  )
                else
                  ..._alerts.asMap().entries.map((e) => AlertItem(
                    alert: e.value,
                    onDismiss: () => setState(() => _alerts.removeAt(e.key)),
                  )),
              ]),
            )),
          ]),
        ),
        const SizedBox(height: 24),

        // ---- TRAIN TABLE ----
        _sectionLabel('Train Status'),
        const SizedBox(height: 12),
        TrainTable(trains: _trains),
        const SizedBox(height: 28),
      ]),
    );
  }

  // ---- HELPERS ----
  Widget _sectionLabel(String text) {
    return Text(text.toUpperCase(),
      style: GoogleFonts.barlowCondensed(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: AppColors.muted));
  }

  Widget _panel({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Text(title.toUpperCase(),
            style: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: AppColors.textMain)),
        ),
        Padding(padding: const EdgeInsets.all(16), child: child),
      ]),
    );
  }

  Widget _alertMini(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Text('$count', style: GoogleFonts.barlowCondensed(fontSize: 26, fontWeight: FontWeight.w700, color: color, height: 1)),
          const SizedBox(height: 2),
          Text(label.toUpperCase(), style: GoogleFonts.dmMono(fontSize: 9, color: color.withOpacity(0.9), letterSpacing: 0.7)),
        ]),
      ),
    );
  }
}