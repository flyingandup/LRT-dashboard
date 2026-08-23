part of 'example.dart';

class GetAllStationsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetAllStationsVariablesBuilder(this._dataConnect, );
  Deserializer<GetAllStationsData> dataDeserializer = (dynamic json)  => GetAllStationsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetAllStationsData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetAllStationsData, void> ref() {
    
    return _dataConnect.query("GetAllStations", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllStationsStations {
  final String name;
  GetAllStationsStations.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllStationsStations otherTyped = other as GetAllStationsStations;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetAllStationsStations({
    required this.name,
  });
}

@immutable
class GetAllStationsData {
  final List<GetAllStationsStations> stations;
  GetAllStationsData.fromJson(dynamic json):
  
  stations = (json['stations'] as List<dynamic>)
        .map((e) => GetAllStationsStations.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllStationsData otherTyped = other as GetAllStationsData;
    return stations == otherTyped.stations;
    
  }
  @override
  int get hashCode => stations.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['stations'] = stations.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllStationsData({
    required this.stations,
  });
}

