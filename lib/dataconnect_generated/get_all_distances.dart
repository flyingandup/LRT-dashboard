part of 'example.dart';

class GetAllDistancesVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  GetAllDistancesVariablesBuilder(
    this._dataConnect,
  );
  Deserializer<GetAllDistancesData> dataDeserializer =
      (dynamic json) => GetAllDistancesData.fromJson(jsonDecode(json));

  Future<QueryResult<GetAllDistancesData, void>> execute() {
    return ref().execute();
  }

  QueryRef<GetAllDistancesData, void> ref() {
    return _dataConnect.query(
        "GetAllDistances", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllDistancesDistances {
  final String id;
  final double distance;
  final GetAllDistancesDistancesFirstStation firstStation;
  final GetAllDistancesDistancesSecondStation secondStation;
  final int orderIndex;
  GetAllDistancesDistances.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']),
        distance = nativeFromJson<double>(json['distance']),
        firstStation =
            GetAllDistancesDistancesFirstStation.fromJson(json['firstStation']),
        secondStation = GetAllDistancesDistancesSecondStation.fromJson(
            json['secondStation']),
        orderIndex = nativeFromJson<int>(json['orderIndex']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllDistancesDistances otherTyped =
        other as GetAllDistancesDistances;
    return id == otherTyped.id &&
        distance == otherTyped.distance &&
        firstStation == otherTyped.firstStation &&
        secondStation == otherTyped.secondStation &&
        orderIndex == otherTyped.orderIndex;
  }

  @override
  int get hashCode => Object.hashAll([
        id.hashCode,
        distance.hashCode,
        firstStation.hashCode,
        secondStation.hashCode,
        orderIndex.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['distance'] = nativeToJson<double>(distance);
    json['firstStation'] = firstStation.toJson();
    json['secondStation'] = secondStation.toJson();
    json['orderIndex'] = nativeToJson<int>(orderIndex);
    return json;
  }

  GetAllDistancesDistances({
    required this.id,
    required this.distance,
    required this.firstStation,
    required this.secondStation,
    required this.orderIndex,
  });
}

@immutable
class GetAllDistancesDistancesFirstStation {
  final String id;
  final String name;
  GetAllDistancesDistancesFirstStation.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']),
        name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllDistancesDistancesFirstStation otherTyped =
        other as GetAllDistancesDistancesFirstStation;
    return id == otherTyped.id && name == otherTyped.name;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetAllDistancesDistancesFirstStation({
    required this.id,
    required this.name,
  });
}

@immutable
class GetAllDistancesDistancesSecondStation {
  final String id;
  final String name;
  GetAllDistancesDistancesSecondStation.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']),
        name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllDistancesDistancesSecondStation otherTyped =
        other as GetAllDistancesDistancesSecondStation;
    return id == otherTyped.id && name == otherTyped.name;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetAllDistancesDistancesSecondStation({
    required this.id,
    required this.name,
  });
}

@immutable
class GetAllDistancesData {
  final List<GetAllDistancesDistances> distances;
  GetAllDistancesData.fromJson(dynamic json)
      : distances = (json['distances'] as List<dynamic>)
            .map((e) => GetAllDistancesDistances.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
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
