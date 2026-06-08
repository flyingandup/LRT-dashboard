// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<Summary> fetchSummary() async {
    final res = await http.get(Uri.parse('$baseUrl/api/summary'));
    if (res.statusCode == 200) return Summary.fromJson(jsonDecode(res.body));
    throw Exception('Failed to load summary');
  }

  static Future<List<Train>> fetchTrains() async {
    final res = await http.get(Uri.parse('$baseUrl/api/trains'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['trains'] as List).map((t) => Train.fromJson(t)).toList();
    }
    throw Exception('Failed to load trains');
  }

  static Future<List<Alert>> fetchAlerts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/alerts'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['alerts'] as List).map((a) => Alert.fromJson(a)).toList();
    }
    throw Exception('Failed to load alerts');
  }

  static Future<MileageChart> fetchMileageChart() async {
    final res = await http.get(Uri.parse('$baseUrl/api/mileage-chart'));
    if (res.statusCode == 200) return MileageChart.fromJson(jsonDecode(res.body));
    throw Exception('Failed to load chart data');
  }
}
