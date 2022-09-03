import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:leatracker/home.dart';
import 'package:leatracker/models/position.dart';
import 'package:leatracker/services/db.service.dart';
import 'package:leatracker/services/num.service.dart';
import 'package:leatracker/services/tracking.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackground = "fetchBackground";
const purge = "purge";

void callbackDispatcher() {

  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        await Firebase.initializeApp();
        await TrackingService.track((p) {
          DbService.save(
            LeaPosition(
                longitude: p.longitude,
                latitude: p.latitude,
                at: DateTime.now()
            )
          );
        });
        break;
      case purge:
        await Firebase.initializeApp();
        await DbService.purge();
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var getIt = GetIt.instance;

  var sharedPreferences = await SharedPreferences.getInstance();
  var numService = NumService(sharedPreferences);
  getIt.registerSingleton(numService);

  await Firebase.initializeApp();

  await TrackingService.init();

  bool tracked = await rootBundle.loadString("config/conf.json")
      .then((value) => json.decode(value)["tracked"] as bool);

  if(tracked) {

    await numService.init();

    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    Workmanager().registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: const Duration(minutes: 15),
    );

    Workmanager().registerPeriodicTask(
      "2",
      purge,
      initialDelay: const Duration(days: 7),
      frequency: const Duration(days: 7),
    );
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp(tracked: tracked));
}

class MyApp extends StatelessWidget {

  final bool tracked;

  const MyApp({Key? key, required this.tracked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Home(tracked: tracked),
    );
  }
}



