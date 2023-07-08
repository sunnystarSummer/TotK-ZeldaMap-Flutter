import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../data/json_file/marker_file.dart';
import '../base/zelda_object.dart';
import '../map/map_type.dart';

//'1925':神廟
class Shrine extends ZeldaObject {
  Shrine(super.botWMarker);

  static String markerCategoryId = '2125';

  //尋找神廟
  static Future<List<Marker>> findPointMarkers(
      {OnMarkerPressed onPressed,
      required MapType mapType,
      required double opacity,
      double zoom = 2}) async {
    var allShrineList = await BotWMarksFile.findMarkers([markerCategoryId],
        markerImage: (botWMarker) {
          if (botWMarker.mapId != mapType.mapId) {
            return null;
          } else {
            var assetPath = '';
            if (botWMarker.mapId == MapType.sky.mapId) {
              assetPath = 'assets/TotK/icon/locations/sky.png';
            } else if (botWMarker.mapId == MapType.surface.mapId) {
              assetPath = 'assets/TotK/icon/locations/surface.png';
            } else if (botWMarker.mapId == MapType.depths.mapId) {
              assetPath = 'assets/TotK/icon/locations/depths.png';
            }

            assetPath = 'assets/TotK/icon/shrine.png';

            if (assetPath.isNotEmpty) {
              return Opacity(
                opacity: opacity,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent, //// 設定背景顏色
                    shape: BoxShape.circle, // 設定形狀為圓形
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image(
                      image: AssetImage(assetPath),
                    ),
                  ),
                ),
              );
            }
          }

          return null;
        },
        zoom: zoom,
        onPressed: (context, category, botWMarker, botWMarkerList) {
          onPressed?.call(context, category, botWMarker, botWMarkerList);
        });

    return allShrineList;
  }
}

// class LightRoot extends ZeldaObject {
//   LightRoot(super.botWMarker);
//
//   static String markerCategoryId = '2125';
//
//   //尋找神廟
//   static Future<List<Marker>> findPointMarkers(
//       {OnMarkerPressed onPressed, double zoom = 2}) async {
//     final allShrineList = BotWMarksFile.findMarkers([markerCategoryId],
//         image: const Image(
//           image: AssetImage('assets/TotK/icon/shrine.png'),
//         ),
//         zoom: zoom, onPressed: (context, category, botWMarker, botWMarkerList) {
//       onPressed?.call(context, category, botWMarker, botWMarkerList);
//     });
//
//     return allShrineList;
//   }
// }
