library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'get_all_distances.dart';

part 'get_all_stations.dart';

part 'update_station.dart';

part 'delete_station.dart';

part 'add_station.dart';







class ExampleConnector {
  
  
  GetAllDistancesVariablesBuilder getAllDistances () {
    return GetAllDistancesVariablesBuilder(dataConnect, );
  }
  
  
  GetAllStationsVariablesBuilder getAllStations () {
    return GetAllStationsVariablesBuilder(dataConnect, );
  }
  
  
  UpdateStationVariablesBuilder updateStation ({required String id, required String name, }) {
    return UpdateStationVariablesBuilder(dataConnect, id: id,name: name,);
  }
  
  
  DeleteStationVariablesBuilder deleteStation ({required String id, }) {
    return DeleteStationVariablesBuilder(dataConnect, id: id,);
  }
  
  
  AddStationVariablesBuilder addStation ({required String name, }) {
    return AddStationVariablesBuilder(dataConnect, name: name,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'asia-southeast2',
    'example',
    'lrtproject',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
