import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../data/json_file/marker_file.dart';
import '../../data/model/category.dart';
import '../../data/model/marker.dart';
import '../base/zelda_object.dart';

class Tower extends ZeldaObject {
  Tower(super.botWMarker);

  static String markerCategoryId = '2123';

  //尋找塔
  static Future<List<Marker>> findPointMarkers(
      {required void Function(
              BuildContext, Category, BotWMarker, List<BotWMarker>)?
          onPressed,
      double zoom = 2}) async {
    final allShrineList = BotWMarksFile.findMarkers([markerCategoryId],
        markerImage: (botWMarker) {
          return const Image(
            image: AssetImage('assets/TotK/icon/tower.png'),
          );
        },
        zoom: zoom,
        onPressed: (context, category, botWMarker, botWMarkerList) {
          onPressed?.call(context, category, botWMarker, botWMarkerList);
        });

    return allShrineList;
  }
}
