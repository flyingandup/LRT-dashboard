import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackops/dataconnect_generated/example.dart';
import 'package:trackops/models/models.dart';
import 'package:trackops/services/csv_service.dart';
import 'package:trackops/services/firebase_service.dart';
import 'package:trackops/theme.dart';
import 'package:trackops/widgets/app_header.dart';
import 'package:trackops/widgets/distance_table.dart';
import 'package:trackops/widgets/import_csv_button.dart';
import 'package:trackops/widgets/station_table.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _stationsScreenState();
}

class _stationsScreenState extends State<StationsScreen> {
  List<Map<String, dynamic>> stations = [];
  List<Map<String, dynamic>> distances = [];
  List<List<dynamic>> current_distances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStations();
    _loadDistances();
  }

  Future<void> _loadStations() async {
    try {
      final result = await ExampleConnector.instance.getAllStations().execute();
      setState(() {
        stations = result.data.stations
            .map((s) => {'id': s.id, 'name': s.name, 'order': s.orderIndex})
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading stations: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadDistances() async {
    try {
      final result =
          await ExampleConnector.instance.getAllDistances().execute();
      setState(() {
        distances = result.data.distances
            .map((d) => {
                  'id': d.id,
                  'firstStationName': d.firstStation.name,
                  'firstStationId': d.firstStation.id,
                  'secondStationName': d.secondStation.name,
                  'secondStationId': d.secondStation.id,
                  'distance': d.distance
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading distances: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: StreamBuilder<List<Train>>(
        stream: FirebaseService.trainsStream(),
        builder: (context, snapshot) {
          return Column(
            children: [
              AppHeader(isConnected: snapshot.hasData, returnHome: true),
              Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildBody(
                          snapshot,
                          stations,
                        ))
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(AsyncSnapshot<List<Train>> snapshot,
      List<Map<String, dynamic>> stations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _sectionLabel('Stations'),
                        const Spacer(),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () => _showAddDialog(context),
                            label: Text('Add Station',
                                style: GoogleFonts.barlow(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    height: 0)),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    StationTable(
                      stations: stations,
                      onEditStation: (String id, String newName) async {
                        try {
                          await ExampleConnector.instance
                              .updateStation(id: id, name: newName)
                              .execute();
                          // Refresh station list state here
                          await _loadStations();
                        } catch (e) {
                          debugPrint('Failed to update station: $e');
                        }
                      },
                      onDeleteStation: (String id) async {
                        try {
                          await ExampleConnector.instance
                              .deleteStation(id: id)
                              .execute();
                          await _loadStations();
                        } catch (e) {
                          debugPrint('Failed to delete station: $e');
                        }
                      },
                      onUpdateStationOrder: (currentIdx, targetIdx) =>
                          _moveStation(currentIdx, targetIdx),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _sectionLabel('Distances'),
                        const Spacer(),
                        ImportCsvButton(
                          onValueSelected: (newValue) async {
                            await _loadStations();

                            if (!mounted) return;

                            setState(() {
                              current_distances = newValue;
                            });

                            await _updateDistances(newValue, context);
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    DistanceTable(distances: distances)
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(text.toUpperCase(),
        style: GoogleFonts.barlowCondensed(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: AppColors.muted));
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();

    int nextOrderIndex =
        stations.isEmpty ? 0 : (stations.last['order'] as int) + 1;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Add Station',
            style: GoogleFonts.barlow(
                fontWeight: FontWeight.w600, color: AppColors.textMain)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
              labelText: 'Station Name', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel',
                style: GoogleFonts.barlow(
                    color: AppColors.muted, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              elevation: 0,
            ),
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                try {
                  await ExampleConnector.instance
                      .addStation(name: newName, orderIndex: nextOrderIndex)
                      .execute();
                  await _loadStations();
                } catch (e) {
                  debugPrint('Failed to add station: $e');
                }
              }
              if (!mounted || !navigator.mounted) return;
              navigator.pop();
            },
            child: Text('Save',
                style: GoogleFonts.barlow(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Future<void> _moveStation(int currentIdx, int targetIdx) async {
    if (targetIdx < 0 || targetIdx >= stations.length) return;

    final currentStation = stations[currentIdx];
    final targetStation = stations[targetIdx];

    final currentId = currentStation['id'];
    final targetId = targetStation['id'];

    final currentOrder = currentStation['order'];
    final targetOrder = targetStation['order'];

    try {
      await ExampleConnector.instance
          .updateStationOrder(id: currentId, orderIndex: targetOrder)
          .execute();

      await ExampleConnector.instance
          .updateStationOrder(id: targetId, orderIndex: currentOrder)
          .execute();
      await _loadStations();
    } catch (e) {
      debugPrint("Error updating station order: $e");
    }
  }

  Future<void> _updateDistances(
      List<List<dynamic>> rows, BuildContext context) async {
    final cleanedRows = csvHeaderRemover(rows);
    if (validateStations(cleanedRows, stations)) {
      final result = transformDistances(cleanedRows, stations);
      await FirebaseService.bulkInsertDistances(result);

      await _loadDistances();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Distances imported successfully'),
          backgroundColor: AppColors.accent,
        ),
      );
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CSV file is invalid or contains unknown stations.'),
          backgroundColor: AppColors.critical,
        ),
      );
    }
  }
}
