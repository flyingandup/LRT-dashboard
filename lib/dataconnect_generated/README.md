# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetAllDistances
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getAllDistances().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAllDistancesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAllDistances();
GetAllDistancesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getAllDistances().ref();
ref.execute();

ref.subscribe(...);
```


### GetAllStations
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getAllStations().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAllStationsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAllStations();
GetAllStationsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getAllStations().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### UpdateStation
#### Required Arguments
```dart
String id = ...;
String name = ...;
ExampleConnector.instance.updateStation(
  id: id,
  name: name,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateStationData, UpdateStationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateStation(
  id: id,
  name: name,
);
UpdateStationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;

final ref = ExampleConnector.instance.updateStation(
  id: id,
  name: name,
).ref();
ref.execute();
```


### DeleteStation
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteStation(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteStationData, DeleteStationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteStation(
  id: id,
);
DeleteStationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteStation(
  id: id,
).ref();
ref.execute();
```


### AddStation
#### Required Arguments
```dart
String name = ...;
int orderIndex = ...;
ExampleConnector.instance.addStation(
  name: name,
  orderIndex: orderIndex,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddStationData, AddStationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addStation(
  name: name,
  orderIndex: orderIndex,
);
AddStationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;
int orderIndex = ...;

final ref = ExampleConnector.instance.addStation(
  name: name,
  orderIndex: orderIndex,
).ref();
ref.execute();
```


### UpdateStationOrder
#### Required Arguments
```dart
String id = ...;
int orderIndex = ...;
ExampleConnector.instance.updateStationOrder(
  id: id,
  orderIndex: orderIndex,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateStationOrderData, UpdateStationOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateStationOrder(
  id: id,
  orderIndex: orderIndex,
);
UpdateStationOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
int orderIndex = ...;

final ref = ExampleConnector.instance.updateStationOrder(
  id: id,
  orderIndex: orderIndex,
).ref();
ref.execute();
```


### ClearDistance
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.clearDistance().execute();
```



#### Return Type
`execute()` returns a `OperationResult<ClearDistanceData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.clearDistance();
ClearDistanceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.clearDistance().ref();
ref.execute();
```


### InsertSingleDistance
#### Required Arguments
```dart
String firstStationId = ...;
String secondStationId = ...;
double distance = ...;
ExampleConnector.instance.insertSingleDistance(
  firstStationId: firstStationId,
  secondStationId: secondStationId,
  distance: distance,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<InsertSingleDistanceData, InsertSingleDistanceVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.insertSingleDistance(
  firstStationId: firstStationId,
  secondStationId: secondStationId,
  distance: distance,
);
InsertSingleDistanceData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String firstStationId = ...;
String secondStationId = ...;
double distance = ...;

final ref = ExampleConnector.instance.insertSingleDistance(
  firstStationId: firstStationId,
  secondStationId: secondStationId,
  distance: distance,
).ref();
ref.execute();
```

