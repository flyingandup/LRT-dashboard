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

factory Train.fromFirebase(String id, Map<dynamic, dynamic> data) {
  return Train(
    id:          id,
    name:        data['name']?.toString()         ?? '',
    status:      data['status']?.toString()       ?? 'active',
    mileage:     (data['mileage'] as num?)?.toInt() ?? 0,
    route:       data['route']?.toString()        ?? '',
    lastService: data['last_service']?.toString() ?? '',
  );
}

  bool get isActive => status == 'active';
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
