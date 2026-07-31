// lib/models/models.dart
class Train {
  final String id;
  final String name;
  final String status;
  final int mileage;
  final String route;
  final String lastService;

  Train({
    required this.id,
    required this.name,
    required this.status,
    required this.mileage,
    required this.route,
    required this.lastService,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      id:          json['id'] ?? '',
      name:        json['name'] ?? '',
      status:      json['status'] ?? '',
      mileage:     json['mileage'] ?? 0,
      route:       json['route'] ?? '',
      lastService: json['last_service'] ?? '',
    );
  }

  bool get isActive => status == 'active';
}

class Alert {
  final int id;
  final String severity;
  final String train;
  final String trainName;
  final List<String> milestones; // e.g. ["2,000 km — Visual Inspection", "40,000 km — Extended Systems Check"]
  final List<String> details;    // e.g. ["2,000 km: Visual inspection...", "40,000 km: Function checks..."]
  final String message;
  final String time;

  Alert({
    required this.id,
    required this.severity,
    required this.train,
    required this.trainName,
    required this.milestones,
    required this.details,
    required this.message,
    required this.time,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id:         json['id'] ?? 0,
      severity:   json['severity'] ?? 'info',
      train:      json['train'] ?? '',
      trainName:  json['train_name'] ?? '',
      milestones: List<String>.from(json['milestones'] ?? []),
      details:    List<String>.from(json['details'] ?? []),
      message:    json['message'] ?? '',
      time:       json['time'] ?? '',
    );
  }
}

class Summary {
  final int totalTrains;
  final int active;
  final int maintenance;
  final int totalAlerts;
  final Map<String, int> alertCounts;
  final String timestamp;

  Summary({
    required this.totalTrains,
    required this.active,
    required this.maintenance,
    required this.totalAlerts,
    required this.alertCounts,
    required this.timestamp,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    final counts = json['alert_counts'] as Map<String, dynamic>? ?? {};
    return Summary(
      totalTrains: json['total_trains'] ?? 0,
      active:      json['active'] ?? 0,
      maintenance: json['maintenance'] ?? 0,
      totalAlerts: json['total_alerts'] ?? 0,
      alertCounts: {
        'critical': counts['critical'] ?? 0,
        'warning':  counts['warning']  ?? 0,
        'info':     counts['info']     ?? 0,
      },
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class MileageChart {
  final List<String> labels;
  final List<int> values;
  final List<String> statuses;

  MileageChart({
    required this.labels,
    required this.values,
    required this.statuses,
  });

  factory MileageChart.fromJson(Map<String, dynamic> json) {
    return MileageChart(
      labels:   List<String>.from(json['labels'] ?? []),
      values:   List<int>.from(json['values'] ?? []),
      statuses: List<String>.from(json['statuses'] ?? []),
    );
  }
}