import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';

List<List<dynamic>> convertFromCsv(String csvString) {
  List<List<dynamic>> rows = csv.decode(csvString);
  return rows;
}

List<List<dynamic>> csvHeaderRemover(List<List<dynamic>> rows) {
  // Guard against empty files and files with wrong column counts
  if (rows.isNotEmpty && rows[0].length == 3) {
    String headerOne = rows[0][0].toString().trim().toLowerCase();
    String headerTwo = rows[0][1].toString().trim().toLowerCase();
    String headerThree = rows[0][2].toString().trim().toLowerCase();

    // Check each column against its specific expected header
    bool isColOneHeader = headerOne == 'first station';
    bool isColTwoHeader = headerTwo == 'second station';
    bool isColThreeHeader = headerThree == 'distance' ||
        headerThree == 'distances' ||
        headerThree == 'distance (km)' ||
        headerThree == 'distances (km)';
    bool isNotANumber = double.tryParse(headerThree) == null;

    if (isColOneHeader &&
        isColTwoHeader &&
        (isColThreeHeader || isNotANumber)) {
      rows.removeAt(0);
    }
  }

  return rows;
}

bool validateStations(
    List<List<dynamic>> rows, List<Map<String, dynamic>> stations) {
  if (rows.isEmpty) {
    return false;
  }

  Set<String> validStations = stations
      .map((station) => station['name'].toString().trim().toLowerCase())
      .toSet();

  for (final item in rows) {
    if (item.length != 3) {
      return false;
    }

    String firstStation = item[0].toString().trim().toLowerCase();
    String secondStation = item[1].toString().trim().toLowerCase();
    String distance = item[2].toString().trim();

    if (!(validStations.contains(firstStation)) ||
        !(validStations.contains(secondStation))) {
      return false;
    }

    if (double.tryParse(distance) == null) {
      return false;
    }
  }

  return true;
}

List<Map<String, dynamic>> transformDistances(
    List<List<dynamic>> distances, List<Map<String, dynamic>> stations) {
  final Map<String, String> stationLookup = {
    for (final station in stations)
      station['name'].toString().trim().toLowerCase(): station['id'].toString(),
  };

  return distances.map((d) {
    final String firstStationName = d[0].toString().trim().toLowerCase();
    final String secondStationName = d[1].toString().trim().toLowerCase();
    final double distance = double.parse(d[2].toString());

    return {
      'firstStationId': stationLookup[firstStationName],
      'secondStationId': stationLookup[secondStationName],
      'distance': distance,
    };
  }).toList();
}

List<List<dynamic>> transformDistancesToList(
    List<Map<String, dynamic>> distances) {
  final List<List<dynamic>> rows = [
    ['First Station', 'Second Station', 'Distance'],
    ...distances.map(
      (d) => [d['firstStationName'], d['secondStationName'], d['distance']],
    ),
  ];

  return rows;
}

Future<void> encodeDistancesToCsvFile(
    List<Map<String, dynamic>> distances) async {
  final String csvString = csv.encode(transformDistancesToList(distances));
  final Uint8List bytes = Uint8List.fromList(utf8.encode(csvString));

  await FileSaver.instance.saveFile(
    name: 'distances_export',
    bytes: bytes,
    fileExtension: 'csv',
    mimeType: MimeType.csv,
  );
}
