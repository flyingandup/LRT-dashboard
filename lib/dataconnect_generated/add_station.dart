part of 'example.dart';

class AddStationVariablesBuilder {
  String name;

  final FirebaseDataConnect _dataConnect;
  AddStationVariablesBuilder(this._dataConnect, {required  this.name,});
  Deserializer<AddStationData> dataDeserializer = (dynamic json)  => AddStationData.fromJson(jsonDecode(json));
  Serializer<AddStationVariables> varsSerializer = (AddStationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddStationData, AddStationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddStationData, AddStationVariables> ref() {
    AddStationVariables vars= AddStationVariables(name: name,);
    return _dataConnect.mutation("AddStation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddStationStationInsert {
  final String id;
  AddStationStationInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddStationStationInsert otherTyped = other as AddStationStationInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AddStationStationInsert({
    required this.id,
  });
}

@immutable
class AddStationData {
  final AddStationStationInsert station_insert;
  AddStationData.fromJson(dynamic json):
  
  station_insert = AddStationStationInsert.fromJson(json['station_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddStationData otherTyped = other as AddStationData;
    return station_insert == otherTyped.station_insert;
    
  }
  @override
  int get hashCode => station_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['station_insert'] = station_insert.toJson();
    return json;
  }

  AddStationData({
    required this.station_insert,
  });
}

@immutable
class AddStationVariables {
  final String name;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddStationVariables.fromJson(Map<String, dynamic> json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddStationVariables otherTyped = other as AddStationVariables;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  AddStationVariables({
    required this.name,
  });
}

