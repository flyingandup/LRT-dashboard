// lib/widgets/train_table.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        _buildHeader(),
        ...trains.asMap().entries.map((e) => _buildRow(context, e.value, e.key)),
      ]),
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
        _hCell('Train ID',     flex: 2),
        _hCell('Name',         flex: 3),
        _hCell('Station',      flex: 3),
        _hCell('Route',        flex: 3),
        _hCell('Status',       flex: 2),
        _hCell('Mileage (km)', flex: 2),
        _hCell('Last Service', flex: 2),
        _hCell('Action',       flex: 3),
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

  Widget _buildRow(BuildContext context, Train t, int index) {
    Color statusColor;
    String statusLabel;
    if (t.isBreakdown) {
      statusColor  = AppColors.critical;
      statusLabel  = 'Breakdown';
    } else if (t.isMaintenance) {
      statusColor  = AppColors.maint;
      statusLabel  = 'Maintenance';
    } else {
      statusColor  = AppColors.active;
      statusLabel  = 'Active';
    }

    return Container(
      color: index.isEven ? AppColors.surface : AppColors.surface2,
      child: Row(children: [
        Expanded(flex: 2, child: _cell(
          Text(t.id, style: GoogleFonts.dmMono(fontSize: 12, color: AppColors.muted)))),
        Expanded(flex: 3, child: _cell(
          Text(t.name, style: GoogleFonts.barlow(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMain)),
        )),
        Expanded(flex: 3, child: _cell(
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t.stationName.isNotEmpty ? t.stationName : '—',
              style: GoogleFonts.barlow(fontSize: 13, color: AppColors.textMain)),
            if (t.stationId.isNotEmpty)
              Text(t.stationId,
                style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
          ]),
        )),
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
              Container(width: 6, height: 6,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text(statusLabel,
                style: GoogleFonts.dmMono(fontSize: 11, fontWeight: FontWeight.w500, color: statusColor)),
            ]),
          ),
        )),
        Expanded(flex: 2, child: _cell(
          Text(_fmt(t.mileage), style: GoogleFonts.dmMono(fontSize: 13, color: AppColors.textMain)))),
        Expanded(flex: 2, child: _cell(
          Text(t.lastService, style: GoogleFonts.dmMono(fontSize: 12, color: AppColors.muted)))),
        // Action buttons
        Expanded(flex: 3, child: _cell(
          _buildActions(context, t),
        )),
      ]),
    );
  }

  Widget _buildActions(BuildContext context, Train t) {
    if (t.isActive) {
      return Row(children: [
        _actionButton(label: 'Maintenance', color: AppColors.maint,
          onTap: () => _showMaintenanceDialog(context, t)),
        const SizedBox(width: 6),
        _actionButton(label: 'Breakdown', color: AppColors.critical,
          onTap: () => _showBreakdownDialog(context, t)),
      ]);
    } else if (t.isBreakdown) {
      return _actionButton(label: 'Back to Service', color: AppColors.active,
        onTap: () => _confirmReturnToService(context, t));
    } else {
      return _actionButton(label: 'Set Active', color: AppColors.active,
        onTap: () => _confirmSetActive(context, t));
    }
  }

  Widget _actionButton({required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(label,
          style: GoogleFonts.barlow(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ),
    );
  }

  Widget _cell(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13), child: child);

  // ---- BREAKDOWN DIALOG ----
  void _showBreakdownDialog(BuildContext context, Train t) {
    final breakdownKm = FirebaseService.calcBreakdownKm(t.stationId);
    final newMileage  = t.mileage + breakdownKm.round();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.critical, size: 22),
          const SizedBox(width: 8),
          Text('Record Breakdown',
            style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.critical)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${t.name} (${t.id})',
            style: GoogleFonts.barlow(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMain)),
          const SizedBox(height: 4),
          Text('Current station: ${t.stationName} (${t.stationId})',
            style: GoogleFonts.barlow(fontSize: 13, color: AppColors.muted)),
          const SizedBox(height: 16),
          // Mileage breakdown info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.critical.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.critical.withOpacity(0.2)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Mileage Calculation', style: GoogleFonts.barlow(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted)),
              const SizedBox(height: 8),
              _calcRow('Station to depot entrance', '${(breakdownKm - 1.7).toStringAsFixed(3)} km'),
              _calcRow('Depot entry/exit (×2)',   '1.700 km'),
              const Divider(height: 16),
              _calcRow('Total added',              '${breakdownKm.toStringAsFixed(3)} km', bold: true, color: AppColors.critical),
              const SizedBox(height: 8),
              _calcRow('Current mileage',          '${_fmt(t.mileage)} km'),
              _calcRow('New mileage after breakdown', '${_fmt(newMileage)} km', bold: true),
            ]),
          ),
          const SizedBox(height: 12),
          Text('• Train status will be set to Breakdown', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.muted)),
          Text('• Breakdown count will increment', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.muted)),
          Text('• Mileage will be updated automatically', style: GoogleFonts.barlow(fontSize: 12, color: AppColors.muted)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.barlow(color: AppColors.muted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.critical,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseService.recordBreakdown(t.id, t.stationId, t.mileage);
            },
            child: Text('Confirm Breakdown', style: GoogleFonts.barlow(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _calcRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.barlow(fontSize: 12, color: AppColors.muted)),
        Text(value, style: GoogleFonts.dmMono(fontSize: 12,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
          color: color ?? AppColors.textMain)),
      ]),
    );
  }

  // ---- RETURN TO SERVICE DIALOG ----
  void _confirmReturnToService(BuildContext context, Train t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Return to Service',
          style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textMain)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${t.name} (${t.id})', style: GoogleFonts.barlow(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 12),
          Text('Breakdown resolved. Return this train to active service?',
            style: GoogleFonts.barlow(fontSize: 14, color: AppColors.textMain)),
          if (t.lastBreakdownKmAdded > 0) ...[
            const SizedBox(height: 8),
            Text('Last breakdown added ${t.lastBreakdownKmAdded.toStringAsFixed(3)} km',
              style: GoogleFonts.dmMono(fontSize: 11, color: AppColors.muted)),
          ],
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.barlow(color: AppColors.muted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.active,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseService.returnToService(t.id);
            },
            child: Text('Return to Service', style: GoogleFonts.barlow(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ---- MAINTENANCE DIALOG ----
  void _showMaintenanceDialog(BuildContext context, Train t) {
    final dateController = TextEditingController(
      text: DateTime.now().toIso8601String().substring(0, 10),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Set to Maintenance',
          style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textMain)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${t.name} (${t.id})', style: GoogleFonts.barlow(fontSize: 14, color: AppColors.muted)),
          if (t.stationName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Station: ${t.stationName} (${t.stationId})',
              style: GoogleFonts.barlow(fontSize: 13, color: AppColors.muted)),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Icon(Icons.speed, size: 16, color: AppColors.muted),
              const SizedBox(width: 8),
              Text('Current mileage: ${_fmt(t.mileage)} km',
                style: GoogleFonts.dmMono(fontSize: 13, color: AppColors.textMain)),
            ]),
          ),
          const SizedBox(height: 16),
          Text('Service date', style: GoogleFonts.barlow(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted)),
          const SizedBox(height: 6),
          TextField(
            controller: dateController,
            style: GoogleFonts.dmMono(fontSize: 13, color: AppColors.textMain),
            decoration: InputDecoration(
              hintText: 'YYYY-MM-DD',
              hintStyle: GoogleFonts.dmMono(fontSize: 13, color: AppColors.muted),
              filled: true, fillColor: AppColors.surface2,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
            ),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.barlow(color: AppColors.muted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.maint,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseService.setMaintenance(t.id, t.mileage);
              await FirebaseService.updateLastService(t.id, dateController.text, t.mileage);
            },
            child: Text('Confirm', style: GoogleFonts.barlow(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ---- SET ACTIVE DIALOG ----
  void _confirmSetActive(BuildContext context, Train t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Set Back to Active',
          style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textMain)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${t.name} (${t.id})', style: GoogleFonts.barlow(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 12),
          Text('Maintenance is complete. Set this train back to active?',
            style: GoogleFonts.barlow(fontSize: 14, color: AppColors.textMain)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.barlow(color: AppColors.muted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.active,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseService.setActive(t.id);
            },
            child: Text('Set Active', style: GoogleFonts.barlow(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
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
