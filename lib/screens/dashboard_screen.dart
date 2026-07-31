// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../services/milestone_service.dart';
import '../theme.dart';
import '../widgets/kpi_card.dart';
import '../widgets/grouped_alert_item.dart';
import '../widgets/train_table.dart';
import '../widgets/mileage_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: StreamBuilder<List<Train>>(
        stream: FirebaseService.trainsStream(),
        builder: (context, snapshot) {
          return Column(children: [
            _buildHeader(snapshot),
            Expanded(child: _buildBody(snapshot)),
          ]);
        },
      ),
    );
  }

  Widget _buildHeader(AsyncSnapshot<List<Train>> snapshot) {
    final isConnected = snapshot.hasData;
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
            const TextSpan(text: 'Ops', style: TextStyle(color: AppColors.accent)),
          ],
        )),
        const Spacer(),
        Container(width: 8, height: 8,
          decoration: BoxDecoration(
            color: isConnected ? AppColors.active : AppColors.critical,
            shape: BoxShape.circle,
          )),
        const SizedBox(width: 6),
        Text(isConnected ? 'LIVE' : 'CONNECTING...',
          style: GoogleFonts.dmMono(fontSize: 12, color: isConnected ? AppColors.active : AppColors.critical)),
        const SizedBox(width: 16),
        Text('Firebase Realtime DB',
          style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
      ]),
    );
  }

  Widget _buildBody(AsyncSnapshot<List<Train>> snapshot) {
    if (snapshot.hasError) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.cloud_off, color: AppColors.critical, size: 48),
        const SizedBox(height: 16),
        Text('Firebase connection error', style: GoogleFonts.barlow(color: AppColors.muted, fontSize: 15)),
        const SizedBox(height: 8),
        Text('${snapshot.error}', style: GoogleFonts.dmMono(color: AppColors.muted, fontSize: 12)),
      ]));
    }

    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    final trains        = snapshot.data!;
    final alerts        = MilestoneService.generateAlerts(trains);
    final groupedAlerts = MilestoneService.generateGroupedAlerts(trains);
    final counts        = MilestoneService.countBySeverity(alerts);
    final active        = trains.where((t) => t.isActive).length;
    final maint         = trains.length - active;
    final hasCrit       = (counts['critical'] ?? 0) > 0;
    final activePct     = trains.isNotEmpty ? (active / trains.length * 100).round() : 0;
    final maintPct      = trains.isNotEmpty ? (maint  / trains.length * 100).round() : 0;

    // Split trains by line
    final bpTrains = trains.where((t) => t.id.startsWith('BP')).toList();
    final pgTrains = trains.where((t) => t.id.startsWith('PG')).toList();
    final skTrains = trains.where((t) => t.id.startsWith('SK')).toList();

    // Flex values proportional to train count so bar widths stay consistent
    // BP=20, PG=32, SK=7 → flex 20, 32, 7
    final bpFlex = bpTrains.length;
    final pgFlex = pgTrains.length;
  

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ---- KPI CARDS ----
        _sectionLabel('Fleet Overview'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: KpiCard(label: 'Total Trains',   value: '${trains.length}', sub: 'Fleet size',            accentColor: AppColors.accent)),
          const SizedBox(width: 16),
          Expanded(child: KpiCard(label: 'Active',         value: '$active',          sub: '$activePct% in service', accentColor: AppColors.active)),
          const SizedBox(width: 16),
          Expanded(child: KpiCard(label: 'In Maintenance', value: '$maint',           sub: '$maintPct% of fleet',    accentColor: AppColors.maint)),
          const SizedBox(width: 16),
          Expanded(child: KpiCard(
            label: 'Active Alerts',
            value: '${alerts.length}',
            sub: '${counts['critical'] ?? 0} critical',
            accentColor: alerts.isEmpty ? AppColors.active : hasCrit ? AppColors.critical : AppColors.warning,
          )),
        ]),
        const SizedBox(height: 24),

        // ---- 3 CHARTS — widths proportional to train count ----
        _sectionLabel('Mileage per Train'),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: Row(children: [
            // BP and PG share remaining space proportionally
            Expanded(
              flex: bpFlex,
              child: _chartPanel(child: MileageBarChart(trains: bpTrains, title: 'Bukit Panjang (${bpTrains.length})')),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: pgFlex,
              child: _chartPanel(child: MileageBarChart(trains: pgTrains, title: 'Punggol (${pgTrains.length})')),
            ),
            const SizedBox(width: 12),
            // SK gets a fixed minimum width so it never looks too cramped
            SizedBox(
              width: 280,
              child: _chartPanel(child: MileageBarChart(trains: skTrains, title: 'Sengkang (${skTrains.length})')),
            ),
          ]),
        ),
        const SizedBox(height: 24),

        // ---- ALERTS + TRAIN TABLE ----
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PM Alerts — scrollable
            SizedBox(
              width: 400,
              child: Container(
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
                    child: Text('PM MILESTONE ALERTS',
                      style: GoogleFonts.barlowCondensed(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: AppColors.textMain)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      _alertMini('Critical', counts['critical'] ?? 0, AppColors.critical),
                      const SizedBox(width: 8),
                      _alertMini('Warning',  counts['warning']  ?? 0, AppColors.warning),
                      const SizedBox(width: 8),
                      _alertMini('Info',     counts['info']     ?? 0, AppColors.info),
                    ]),
                  ),
                  Divider(color: AppColors.border, height: 1),
                  if (groupedAlerts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(child: Text('No alerts — all trains on track.',
                        style: GoogleFonts.barlow(fontSize: 13, color: AppColors.muted))),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 500),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupedAlerts.length,
                        itemBuilder: (_, i) => GroupedAlertItem(alert: groupedAlerts[i]),
                      ),
                    ),
                ]),
              ),
            ),
            const SizedBox(width: 20),

            // Train table
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionLabel('Train Status'),
                const SizedBox(height: 12),
                TrainTable(trains: trains),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 28),
      ]),
    );
  }

  Widget _chartPanel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text.toUpperCase(),
      style: GoogleFonts.barlowCondensed(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: AppColors.muted));
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
