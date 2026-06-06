// lib/services/milestone_service.dart
import '../models/models.dart';

class GroupedAlert {
  final String trainId;
  final String trainName;
  final String severity;
  final List<MilestoneEntry> entries;

  GroupedAlert({
    required this.trainId,
    required this.trainName,
    required this.severity,
    required this.entries,
  });
}

class MilestoneEntry {
  final String cycle;
  final String label;
  final String detail;
  final String severity;
  final int kmRemaining;

  MilestoneEntry({
    required this.cycle,
    required this.label,
    required this.detail,
    required this.severity,
    required this.kmRemaining,
  });
}

class Alert {
  final String severity;
  final String train;
  final String cycle;
  final String label;
  final String message;
  final int kmRemaining;

  Alert({
    required this.severity,
    required this.train,
    required this.cycle,
    required this.label,
    required this.message,
    required this.kmRemaining,
  });
}

class MilestoneService {
  static const int overhaulKm = 360000;

  static const List<Map<String, dynamic>> milestones = [
    {'km': 2000,   'cycle': '2,000 km',   'label': 'Visual Inspection',        'detail': 'Visual inspection of general train condition.',             'severity': 'info',     'threshold': 200},
    {'km': 13000,  'cycle': '13,000 km',  'label': 'Function Check — Doors',   'detail': 'Function checks on Emergency Door and Saloon Door.',        'severity': 'info',     'threshold': 500},
    {'km': 40000,  'cycle': '40,000 km',  'label': 'Extended Systems Check',   'detail': 'Function checks on Air-con and Brakes.',                    'severity': 'warning',  'threshold': 500},
    {'km': 120000, 'cycle': '120,000 km', 'label': 'Detailed Component Check', 'detail': 'Greasing, Air Compressor inspection, Filter Cleaning.',      'severity': 'warning',  'threshold': 1000},
    {'km': 360000, 'cycle': '360,000 km', 'label': 'Full Overhaul',            'detail': 'Removal of Bogie and overhaul of major vehicle components.', 'severity': 'critical', 'threshold': 1000},
  ];

  static const _severityOrder = {'critical': 0, 'warning': 1, 'info': 2};

  // Check if train has reached or is approaching overhaul milestone
  static bool _isOverhaulDue(int mileage) {
    final cycleNum    = mileage ~/ overhaulKm;
    final nextDue     = (cycleNum + 1) * overhaulKm;
    final kmRemaining = nextDue - mileage;
    // Overhaul is due now OR within its threshold
    return (mileage > 0 && mileage % overhaulKm == 0) || kmRemaining <= 1000;
  }

  static List<GroupedAlert> generateGroupedAlerts(List<Train> trains) {
    final grouped = <GroupedAlert>[];

    for (final train in trains) {
      final entries = <MilestoneEntry>[];

      // If overhaul is due, ONLY show the overhaul alert
      if (_isOverhaulDue(train.mileage)) {
        final ms          = milestones.last; // Full Overhaul
        final cycleKm     = ms['km'] as int;
        final nextDue     = ((train.mileage ~/ cycleKm) + 1) * cycleKm;
        final kmRemaining = nextDue - train.mileage;
        entries.add(MilestoneEntry(
          cycle:        ms['cycle'],
          label:        ms['label'],
          detail:       ms['detail'],
          severity:     ms['severity'],
          kmRemaining:  train.mileage % cycleKm == 0 ? 0 : kmRemaining,
        ));
      } else {
        // Normal milestone checks — skip overhaul
        for (final ms in milestones.where((m) => m['km'] != overhaulKm)) {
          final cycleKm     = ms['km'] as int;
          final threshold   = ms['threshold'] as int;
          final nextDue     = ((train.mileage ~/ cycleKm) + 1) * cycleKm;
          final kmRemaining = nextDue - train.mileage;

          if (train.mileage > 0 && train.mileage % cycleKm == 0) {
            entries.add(MilestoneEntry(
              cycle: ms['cycle'], label: ms['label'],
              detail: ms['detail'], severity: ms['severity'], kmRemaining: 0,
            ));
          } else if (kmRemaining > 0 && kmRemaining <= threshold) {
            entries.add(MilestoneEntry(
              cycle: ms['cycle'], label: ms['label'],
              detail: ms['detail'], severity: ms['severity'], kmRemaining: kmRemaining,
            ));
          }
        }
      }

      if (entries.isNotEmpty) {
        entries.sort((a, b) {
          final s = (_severityOrder[a.severity] ?? 2).compareTo(_severityOrder[b.severity] ?? 2);
          return s != 0 ? s : a.kmRemaining.compareTo(b.kmRemaining);
        });
        grouped.add(GroupedAlert(
          trainId: train.id, trainName: train.name,
          severity: entries.first.severity, entries: entries,
        ));
      }
    }

    grouped.sort((a, b) =>
      (_severityOrder[a.severity] ?? 2).compareTo(_severityOrder[b.severity] ?? 2));
    return grouped;
  }

  static List<Alert> generateAlerts(List<Train> trains) {
    final alerts = <Alert>[];
    for (final train in trains) {
      if (_isOverhaulDue(train.mileage)) {
        // Only show overhaul alert
        final ms          = milestones.last;
        final cycleKm     = ms['km'] as int;
        final nextDue     = ((train.mileage ~/ cycleKm) + 1) * cycleKm;
        final kmRemaining = nextDue - train.mileage;
        final isDue       = train.mileage % cycleKm == 0;
        alerts.add(Alert(
          severity: ms['severity'], train: train.id, cycle: ms['cycle'],
          label: ms['label'], kmRemaining: isDue ? 0 : kmRemaining,
          message: isDue
            ? '${train.name} (${train.id}) reached ${_fmt(train.mileage)} km — ${ms['label']} due now.'
            : '${train.name} (${train.id}) approaching ${ms['cycle']} in ${_fmt(kmRemaining)} km — ${ms['label']}.',
        ));
      } else {
        for (final ms in milestones.where((m) => m['km'] != overhaulKm)) {
          final cycleKm     = ms['km'] as int;
          final threshold   = ms['threshold'] as int;
          final nextDue     = ((train.mileage ~/ cycleKm) + 1) * cycleKm;
          final kmRemaining = nextDue - train.mileage;
          if (train.mileage > 0 && train.mileage % cycleKm == 0) {
            alerts.add(Alert(severity: ms['severity'], train: train.id, cycle: ms['cycle'],
              label: ms['label'], kmRemaining: 0,
              message: '${train.name} (${train.id}) reached ${_fmt(train.mileage)} km — ${ms['label']} due now.'));
          } else if (kmRemaining > 0 && kmRemaining <= threshold) {
            alerts.add(Alert(severity: ms['severity'], train: train.id, cycle: ms['cycle'],
              label: ms['label'], kmRemaining: kmRemaining,
              message: '${train.name} (${train.id}) approaching ${ms['cycle']} in ${_fmt(kmRemaining)} km — ${ms['label']}.'));
          }
        }
      }
    }
    return alerts;
  }

  static Map<String, int> countBySeverity(List<Alert> alerts) {
    final counts = {'critical': 0, 'warning': 0, 'info': 0};
    for (final a in alerts) {
      counts[a.severity] = (counts[a.severity] ?? 0) + 1;
    }
    return counts;
  }

  static String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
