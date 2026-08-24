part of 'example.dart';

class UpdateStationVariablesBuilder {
  String id;
  String name;

  final FirebaseDataConnect _dataConnect;
  UpdateStationVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,});
  Deserializer<UpdateStationData> dataDeserializer = (dynamic json)  => UpdateStationData.fromJson(jsonDecode(json));
  Serializer<UpdateStationVariables> varsSerializer = (UpdateStationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateStationData, UpdateStationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateStationData, UpdateStationVariables> ref() {
    UpdateStationVariables vars= UpdateStationVariables(id: id,name: name,);
    return _dataConnect.mutation("UpdateStation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateStationStationUpdate {
  final String id;
  UpdateStationStationUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateStationStationUpdate otherTyped = other as UpdateStationStationUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateStationStationUpdate({
    required this.id,
  });
}

@immutable
class UpdateStationData {
  final UpdateStationStationUpdate? station_update;
  UpdateStationData.fromJson(dynamic json):
  
  station_update = json['station_update'] == null ? null : UpdateStationStationUpdate.fromJson(json['station_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateStationData otherTyped = other as UpdateStationData;
    return station_update == otherTyped.station_update;
    
  }
  @override
  int get hashCode => station_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (station_update != null) {
      json['station_update'] = station_update!.toJson();
    }
    return json;
  }

  UpdateStationData({
    this.station_update,
  });
}

@immutable
class UpdateStationVariables {
  final String id;
  final String name;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateStationVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateStationVariables otherTyped = other as UpdateStationVariables;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  UpdateStationVariables({
    required this.id,
    required this.name,
  });
}

