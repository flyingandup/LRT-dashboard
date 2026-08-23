import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late Future<List<String>> _stationsFuture;

  @override
  void initState() {
    super.initState();
    _stationsFuture = FirebaseService().fetchStations();
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
                child: FutureBuilder<List<String>>(
                  future: _stationsFuture,
                  builder: (context, stationsSnapshot) {
                    if (stationsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (stationsSnapshot.hasError) {
                      return const Center(
                        child: Text('Unable to load stations'),
                      );
                    }
                    return _buildBody(
                      snapshot,
                      stationsSnapshot.data ?? <String>[],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
      AsyncSnapshot<List<Train>> snapshot, List<String> stations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Stations'),
                    const SizedBox(height: 12),
                    StationTable(stations: stations),
                  ]),
            ),
          ],
        ),
        const SizedBox(height: 28),
      ]),
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
}
