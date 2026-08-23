library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'get_all_distances.dart';

part 'get_all_stations.dart';







class ExampleConnector {
  
  
  GetAllDistancesVariablesBuilder getAllDistances () {
    return GetAllDistancesVariablesBuilder(dataConnect, );
  }
  
  
  GetAllStationsVariablesBuilder getAllStations () {
    return GetAllStationsVariablesBuilder(dataConnect, );
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
