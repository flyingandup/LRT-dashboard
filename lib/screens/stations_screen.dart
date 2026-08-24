import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackops/dataconnect_generated/example.dart';
import 'package:trackops/models/models.dart';
import 'package:trackops/services/firebase_service.dart';
import 'package:trackops/theme.dart';
import 'package:trackops/widgets/app_header.dart';
import 'package:trackops/widgets/station_table.dart';

class stationsScreen extends StatefulWidget {
  const stationsScreen({super.key});

  @override
  State<stationsScreen> createState() => _stationsScreenState();
}

class _stationsScreenState extends State<stationsScreen> {
  List<Map<String, dynamic>> stations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    try {
      final result = await ExampleConnector.instance.getAllStations().execute();
      setState(() {
        stations = result.data.stations
            .map((s) => {'id': s.id, 'name': s.name})
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading stations: $e');
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
                                    height: 1.0)),
                            icon: Icon(
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
                    ),
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
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                try {
                  await ExampleConnector.instance
                      .addStation(name: newName)
                      .execute();
                  await _loadStations();
                } catch (e) {
                  debugPrint('Failed to add station: $e');
                }
              }
              Navigator.pop(dialogContext);
            },
            child: Text('Save',
                style: GoogleFonts.barlow(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
