// lib/services/firebase_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackops/dataconnect_generated/example.dart';
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

  static Future<void> clearMilestoneAlert(
      String trainId, String cycleName, int currentMileage) async {
    final ref = _db.ref('trains/$trainId');
    await ref.update({
      'last_service': DateTime.now().toIso8601String().split('T')[0],
      'last_service_mileage/$cycleName': currentMileage,
    });
  }

  Future<List<Map<String, dynamic>>> fetchStations() async {
    try {
      final result = await ExampleConnector.instance.getAllStations().execute();
      final stations = result.data?.stations ?? [];

      return stations
          .where((station) {
            final id = station.id;
            final name = station.name;

            if (id == null || name == null) return false;
            if (id.toString().trim().isEmpty) return false;
            if (name.trim().isEmpty) return false;

            return true;
          })
          .map((station) =>
              {"id": station.id.trim(), "name": station.name.trim()})
          .toList();
    } catch (e) {
      debugPrint('Error fetching stations: $e');
      return [];
    }
  }
}
