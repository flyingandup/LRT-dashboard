part of 'example.dart';

class ClearDistanceVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ClearDistanceVariablesBuilder(this._dataConnect, );
  Deserializer<ClearDistanceData> dataDeserializer = (dynamic json)  => ClearDistanceData.fromJson(jsonDecode(json));
  
  Future<OperationResult<ClearDistanceData, void>> execute() {
    return ref().execute();
  }

  MutationRef<ClearDistanceData, void> ref() {
    
    return _dataConnect.mutation("ClearDistance", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ClearDistanceData {
  final int distance_deleteMany;
  ClearDistanceData.fromJson(dynamic json):
  
  distance_deleteMany = nativeFromJson<int>(json['distance_deleteMany']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ClearDistanceData otherTyped = other as ClearDistanceData;
    return distance_deleteMany == otherTyped.distance_deleteMany;
    
  }
  @override
  int get hashCode => distance_deleteMany.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['distance_deleteMany'] = nativeToJson<int>(distance_deleteMany);
    return json;
  }

  ClearDistanceData({
    required this.distance_deleteMany,
  });
}

