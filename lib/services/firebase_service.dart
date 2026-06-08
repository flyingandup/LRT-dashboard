// lib/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import '../models/models.dart';

class FirebaseService {
  static final _db = FirebaseDatabase.instance;

  // Listen to trains in real time — updates Flutter whenever Firebase changes
  static Stream<List<Train>> trainsStream() {
    return _db.ref('trains').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final map = Map<dynamic, dynamic>.from(data as Map);
      final trains = map.entries.map((e) {
        return Train.fromFirebase(
          e.key.toString(),
          Map<dynamic, dynamic>.from(e.value as Map),
        );
      }).toList();

      // Sort by train ID
      trains.sort((a, b) => a.id.compareTo(b.id));
      return trains;
    });
  }

  // One-time fetch
  static Future<List<Train>> fetchTrains() async {
    final snapshot = await _db.ref('trains').get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final map = Map<dynamic, dynamic>.from(snapshot.value as Map);
    final trains = map.entries.map((e) {
      return Train.fromFirebase(
        e.key.toString(),
        Map<dynamic, dynamic>.from(e.value as Map),
      );
    }).toList();

    trains.sort((a, b) => a.id.compareTo(b.id));
    return trains;
  }
}
