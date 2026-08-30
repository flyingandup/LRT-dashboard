part of 'example.dart';

class InsertSingleDistanceVariablesBuilder {
  String firstStationId;
  String secondStationId;
  double distance;
  int orderIndex;

  final FirebaseDataConnect _dataConnect;
  InsertSingleDistanceVariablesBuilder(this._dataConnect, {required  this.firstStationId,required  this.secondStationId,required  this.distance,required  this.orderIndex,});
  Deserializer<InsertSingleDistanceData> dataDeserializer = (dynamic json)  => InsertSingleDistanceData.fromJson(jsonDecode(json));
  Serializer<InsertSingleDistanceVariables> varsSerializer = (InsertSingleDistanceVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<InsertSingleDistanceData, InsertSingleDistanceVariables>> execute() {
    return ref().execute();
  }

  MutationRef<InsertSingleDistanceData, InsertSingleDistanceVariables> ref() {
    InsertSingleDistanceVariables vars= InsertSingleDistanceVariables(firstStationId: firstStationId,secondStationId: secondStationId,distance: distance,orderIndex: orderIndex,);
    return _dataConnect.mutation("InsertSingleDistance", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class InsertSingleDistanceDistanceInsert {
  final String id;
  InsertSingleDistanceDistanceInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertSingleDistanceDistanceInsert otherTyped = other as InsertSingleDistanceDistanceInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertSingleDistanceDistanceInsert({
    required this.id,
  });
}

@immutable
class InsertSingleDistanceData {
  final InsertSingleDistanceDistanceInsert distance_insert;
  InsertSingleDistanceData.fromJson(dynamic json):
  
  distance_insert = InsertSingleDistanceDistanceInsert.fromJson(json['distance_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertSingleDistanceData otherTyped = other as InsertSingleDistanceData;
    return distance_insert == otherTyped.distance_insert;
    
  }
  @override
  int get hashCode => distance_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['distance_insert'] = distance_insert.toJson();
    return json;
  }

  InsertSingleDistanceData({
    required this.distance_insert,
  });
}

@immutable
class InsertSingleDistanceVariables {
  final String firstStationId;
  final String secondStationId;
  final double distance;
  final int orderIndex;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  InsertSingleDistanceVariables.fromJson(Map<String, dynamic> json):
  
  firstStationId = nativeFromJson<String>(json['firstStationId']),
  secondStationId = nativeFromJson<String>(json['secondStationId']),
  distance = nativeFromJson<double>(json['distance']),
  orderIndex = nativeFromJson<int>(json['orderIndex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertSingleDistanceVariables otherTyped = other as InsertSingleDistanceVariables;
    return firstStationId == otherTyped.firstStationId && 
    secondStationId == otherTyped.secondStationId && 
    distance == otherTyped.distance && 
    orderIndex == otherTyped.orderIndex;
    
  }
  @override
  int get hashCode => Object.hashAll([firstStationId.hashCode, secondStationId.hashCode, distance.hashCode, orderIndex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['firstStationId'] = nativeToJson<String>(firstStationId);
    json['secondStationId'] = nativeToJson<String>(secondStationId);
    json['distance'] = nativeToJson<double>(distance);
    json['orderIndex'] = nativeToJson<int>(orderIndex);
    return json;
  }

  InsertSingleDistanceVariables({
    required this.firstStationId,
    required this.secondStationId,
    required this.distance,
    required this.orderIndex,
  });
}

