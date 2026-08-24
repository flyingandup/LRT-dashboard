part of 'example.dart';

class GetAllDistancesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetAllDistancesVariablesBuilder(this._dataConnect, );
  Deserializer<GetAllDistancesData> dataDeserializer = (dynamic json)  => GetAllDistancesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetAllDistancesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetAllDistancesData, void> ref() {
    
    return _dataConnect.query("GetAllDistances", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllDistancesDistances {
  final String id;
  final String firstStation;
  final String secondStation;
  final double distance;
  GetAllDistancesDistances.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  firstStation = nativeFromJson<String>(json['firstStation']),
  secondStation = nativeFromJson<String>(json['secondStation']),
  distance = nativeFromJson<double>(json['distance']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllDistancesDistances otherTyped = other as GetAllDistancesDistances;
    return id == otherTyped.id && 
    firstStation == otherTyped.firstStation && 
    secondStation == otherTyped.secondStation && 
    distance == otherTyped.distance;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, firstStation.hashCode, secondStation.hashCode, distance.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['firstStation'] = nativeToJson<String>(firstStation);
    json['secondStation'] = nativeToJson<String>(secondStation);
    json['distance'] = nativeToJson<double>(distance);
    return json;
  }

  GetAllDistancesDistances({
    required this.id,
    required this.firstStation,
    required this.secondStation,
    required this.distance,
  });
}

@immutable
class GetAllDistancesData {
  final List<GetAllDistancesDistances> distances;
  GetAllDistancesData.fromJson(dynamic json):
  
  distances = (json['distances'] as List<dynamic>)
        .map((e) => GetAllDistancesDistances.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllDistancesData otherTyped = other as GetAllDistancesData;
    return distances == otherTyped.distances;
    
  }
  @override
  int get hashCode => distances.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['distances'] = distances.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllDistancesData({
    required this.distances,
  });
}

