part of 'example.dart';

class DeleteStationVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteStationVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteStationData> dataDeserializer = (dynamic json)  => DeleteStationData.fromJson(jsonDecode(json));
  Serializer<DeleteStationVariables> varsSerializer = (DeleteStationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteStationData, DeleteStationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteStationData, DeleteStationVariables> ref() {
    DeleteStationVariables vars= DeleteStationVariables(id: id,);
    return _dataConnect.mutation("DeleteStation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteStationStationDelete {
  final String id;
  DeleteStationStationDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStationStationDelete otherTyped = other as DeleteStationStationDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteStationStationDelete({
    required this.id,
  });
}

@immutable
class DeleteStationData {
  final DeleteStationStationDelete? station_delete;
  DeleteStationData.fromJson(dynamic json):
  
  station_delete = json['station_delete'] == null ? null : DeleteStationStationDelete.fromJson(json['station_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStationData otherTyped = other as DeleteStationData;
    return station_delete == otherTyped.station_delete;
    
  }
  @override
  int get hashCode => station_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (station_delete != null) {
      json['station_delete'] = station_delete!.toJson();
    }
    return json;
  }

  DeleteStationData({
    this.station_delete,
  });
}

@immutable
class DeleteStationVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteStationVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStationVariables otherTyped = other as DeleteStationVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteStationVariables({
    required this.id,
  });
}

