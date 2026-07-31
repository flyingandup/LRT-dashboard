// lib/models/models.dart
class Train {
  final String id;
  final String name;
  final String status;
  final int mileage;
  final String route;
  final String lastService;
  final Map<String, int> lastServiceMileage;
  final String stationId;
  final String stationName;
  final int breakdownCount;
  final String lastBreakdownStation;
  final double lastBreakdownKmAdded;

  Train({
    required this.id,
    required this.name,
    required this.status,
    required this.mileage,
    required this.route,
    required this.lastService,
    required this.lastServiceMileage,
    required this.stationId,
    required this.stationName,
    required this.breakdownCount,
    required this.lastBreakdownStation,
    required this.lastBreakdownKmAdded,
  });

  factory Train.fromFirebase(String id, Map<dynamic, dynamic> data) {
    final serviceMap = <String, int>{};
    if (data['last_service_mileage'] is Map) {
      (data['last_service_mileage'] as Map).forEach((key, value) {
        serviceMap[key.toString()] = (value as num?)?.toInt() ?? 0;
      });
    }
    return Train(
      id:                    id,
      name:                  data['name']?.toString()                    ?? '',
      status:                data['status']?.toString()                  ?? 'active',
      mileage:               (data['mileage'] as num?)?.toInt()          ?? 0,
      route:                 data['route']?.toString()                   ?? '',
      lastService:           data['last_service']?.toString()            ?? '',
      lastServiceMileage:    serviceMap,
      stationId:             data['station_id']?.toString()              ?? '',
      stationName:           data['station_name']?.toString()            ?? '',
      breakdownCount:        (data['breakdown_count'] as num?)?.toInt()  ?? 0,
      lastBreakdownStation:  data['last_breakdown_station']?.toString()  ?? '',
      lastBreakdownKmAdded:  (data['last_breakdown_km_added'] as num?)?.toDouble() ?? 0.0,
    );
  }

  bool get isActive     => status == 'active';
  bool get isBreakdown  => status == 'breakdown';
  bool get isMaintenance => status == 'maintenance';
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
