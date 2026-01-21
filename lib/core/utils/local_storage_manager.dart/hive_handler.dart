// import 'package:hive_flutter/adapters.dart';

// class HiveHandler {
//   static final HiveHandler _instance = HiveHandler._internal();
//   factory HiveHandler() => _instance;
//   HiveHandler._internal();

//   Future<void> init() async {
//     await Hive.initFlutter();
     // Hive.registerAdapter(TripLocationModelAdapter());
//   }

  // Future<void> saveStartedTrip(StartedTripModel trip) async {
  //   final box = await Hive.openBox<StartedTripModel>('startedTripBox');
  //   await box.put('currentTrip', trip);
  //   await box.close();
  // }

  // Future<StartedTripModel?> getStartedTrip() async {
  //   final box = await Hive.openBox<StartedTripModel>('startedTripBox');
  //   final trip = box.get('currentTrip');
  //   await box.close();
  //   return trip;
  // }

  // Future<void> deleteStartedTrip() async {
  //   final box = await Hive.openBox<StartedTripModel>('startedTripBox');
  //   await box.delete('currentTrip');
  //   await box.close();
  // }
//}
