import 'package:csv/csv.dart';


List<List<dynamic>> convertFromCsv(String csvString) {
  try {
    List<List<dynamic>> rows = csv.decode(csvString);
    return rows;
  } catch (e) {
    print('Error occured trying to process CSV: $e');
    return <List<dynamic>>[];
  }
}