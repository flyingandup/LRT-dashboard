part of 'example.dart';

class UpdateStationOrderVariablesBuilder {
  String id;
  int orderIndex;

  final FirebaseDataConnect _dataConnect;
  UpdateStationOrderVariablesBuilder(this._dataConnect, {required  this.id,required  this.orderIndex,});
  Deserializer<UpdateStationOrderData> dataDeserializer = (dynamic json)  => UpdateStationOrderData.fromJson(jsonDecode(json));
  Serializer<UpdateStationOrderVariables> varsSerializer = (UpdateStationOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateStationOrderData, UpdateStationOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateStationOrderData, UpdateStationOrderVariables> ref() {
    UpdateStationOrderVariables vars= UpdateStationOrderVariables(id: id,orderIndex: orderIndex,);
    return _dataConnect.mutation("UpdateStationOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateStationOrderStationUpdate {
  final String id;
  UpdateStationOrderStationUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateStationOrderStationUpdate otherTyped = other as UpdateStationOrderStationUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateStationOrderStationUpdate({
    required this.id,
  });
}

@immutable
class UpdateStationOrderData {
  final UpdateStationOrderStationUpdate? station_update;
  UpdateStationOrderData.fromJson(dynamic json):
  
  station_update = json['station_update'] == null ? null : UpdateStationOrderStationUpdate.fromJson(json['station_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateStationOrderData otherTyped = other as UpdateStationOrderData;
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

  UpdateStationOrderData({
    this.station_update,
  });
}

@immutable
class UpdateStationOrderVariables {
  final String id;
  final int orderIndex;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateStationOrderVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  orderIndex = nativeFromJson<int>(json['orderIndex']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateStationOrderVariables otherTyped = other as UpdateStationOrderVariables;
    return id == otherTyped.id && 
    orderIndex == otherTyped.orderIndex;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, orderIndex.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['orderIndex'] = nativeToJson<int>(orderIndex);
    return json;
  }

  UpdateStationOrderVariables({
    required this.id,
    required this.orderIndex,
  });
}

