import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../view/location_map/location_map.dart';
import '../view/shrine_map/shrine_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white70,
      statusBarBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'Flutter Map',
      initialRoute: LocationMapView.route,
      routes: <String, WidgetBuilder>{
        //KorokSeedsMapView.route: (context) => const KorokSeedsMapView(),
        //ShrineMapView.route: (context) => const ShrineMapView(),
        LocationMapView.route: (context) => const LocationMapView(),
      },
    );
  }
}
