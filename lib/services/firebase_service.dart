// lib/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/models.dart';

class FirebaseService {
  static final _db = FirebaseDatabase.instance;

  // ---- Depot entry/exit distance (850m x2 = 1.7km) ----
  static const double depotEntryKm = 0.85;

  // ---- Inter-station distances per loop (km) ----
  static const Map<String, double> interStationKm = {
    'BP':    0.557,
    'PG-PE': 0.700,
    'PG-PW': 0.700,
    'SK-SE': 0.700,
    'SK-SW': 0.675,
  };

  // ---- Station order per loop (depot between index 5 and 6) ----
  static const Map<String, List<String>> stationOrder = {
    'BP':    ['BP-000','BP-001','BP-002','BP-003','BP-004','BP-005','BP-006','BP-007','BP-008','BP-009','BP-010','BP-011','BP-012','BP-013'],
    'PG-PE': ['PG-000','PG-PE1','PG-PE2','PG-PE3','PG-PE4','PG-PE5','PG-PE6','PG-PE7'],
    'PG-PW': ['PG-000','PG-PW1','PG-PW2','PG-PW3','PG-PW4','PG-PW5','PG-PW6','PG-PW7'],
    'SK-SE': ['SK-000','SK-SE1','SK-SE2','SK-SE3','SK-SE4','SK-SE5','SK-SE6','SK-SE7','SK-SE8'],
    'SK-SW': ['SK-000','SK-SW1','SK-SW2','SK-SW3','SK-SW4','SK-SW5','SK-SW6','SK-SW7','SK-SW8'],
  };

  // Determine which loop a station belongs to
  static String? _getLoop(String stationId) {
    if (stationId.startsWith('BP'))    return 'BP';
    if (stationId.startsWith('PG-PE')) return 'PG-PE';
    if (stationId.startsWith('PG-PW')) return 'PG-PW';
    if (stationId.startsWith('SK-SE')) return 'SK-SE';
    if (stationId.startsWith('SK-SW')) return 'SK-SW';
    if (stationId == 'PG-000')         return 'PG-PE';
    if (stationId == 'SK-000')         return 'SK-SE';
    return null;
  }

  // Calculate breakdown mileage for a given station
  // = distance to depot (both ways) + depot entry/exit (both ways)
  static double calcBreakdownKm(String stationId) {
    final loop = _getLoop(stationId);
    if (loop == null) return depotEntryKm * 2;

    final order    = stationOrder[loop]!;
    final inter    = interStationKm[loop]!;
    const depotIdx = 5; // depot entrance is at station index 5

    final trainIdx = order.indexOf(stationId);
    if (trainIdx == -1) return depotEntryKm * 2;

    // One way only: breakdown point → depot entrance (station 5)
    // Then + 1.7km fixed depot round trip
    final stationsToDepot = (depotIdx - trainIdx).abs();
    final distToDepot     = stationsToDepot * inter;
    final total           = distToDepot + (depotEntryKm * 2);
    return double.parse(total.toStringAsFixed(3));
  }

  // ---- Stream ----
  static Stream<List<Train>> trainsStream() {
    return _db.ref('trains').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];
      final map = Map<dynamic, dynamic>.from(data as Map);
      final trains = map.entries.map((e) =>
        Train.fromFirebase(e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map))
      ).toList();
      trains.sort((a, b) => a.id.compareTo(b.id));
      return trains;
    });
  }

  // ---- One-time fetch ----
  static Future<List<Train>> fetchTrains() async {
    final snapshot = await _db.ref('trains').get();
    if (!snapshot.exists || snapshot.value == null) return [];
    final map = Map<dynamic, dynamic>.from(snapshot.value as Map);
    final trains = map.entries.map((e) =>
      Train.fromFirebase(e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map))
    ).toList();
    trains.sort((a, b) => a.id.compareTo(b.id));
    return trains;
  }

  // ---- Clear milestone alert ----
  static Future<void> clearMilestoneAlert(String trainId, String cycleName, int currentMileage) async {
    await _db.ref('trains/$trainId').update({
      'last_service': DateTime.now().toIso8601String().split('T')[0],
      'last_service_mileage/$cycleName': currentMileage,
    });
  }

  // ---- Set Maintenance ----
  static Future<void> setMaintenance(String trainId, int currentMileage) async {
    await _db.ref('trains/$trainId').update({
      'status': 'maintenance',
    });
  }

  // ---- Set Active ----
  static Future<void> setActive(String trainId) async {
    await _db.ref('trains/$trainId').update({
      'status': 'active',
    });
  }

  // ---- Update last service ----
  static Future<void> updateLastService(String trainId, String date, int mileage) async {
    await _db.ref('trains/$trainId').update({
      'last_service': date,
    });
  }

  // ---- Record Breakdown ----
  // Adds breakdown mileage (depot round trip + station distance) to train mileage
  static Future<double> recordBreakdown(String trainId, String stationId, int currentMileage) async {
    final breakdownKm = calcBreakdownKm(stationId);
    final newMileage  = currentMileage + (breakdownKm.round());

    await _db.ref('trains/$trainId').update({
      'status':          'breakdown',
      'mileage':         newMileage,
      'breakdown_count': ServerValue.increment(1),
      'last_breakdown_station': stationId,
      'last_breakdown_km_added': breakdownKm,
    });

    return breakdownKm;
  }

  // ---- Return to Service after breakdown ----
  static Future<void> returnToService(String trainId) async {
    await _db.ref('trains/$trainId').update({
      'status': 'active',
    });
  }
}
