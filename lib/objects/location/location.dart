import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';


import '../../component/text_view.dart';
import '../../data/json_file/marker_file.dart';
import '../../utils/dialog_util.dart';
import '../base/zelda_object.dart';
import '../map/map_type.dart';

class LocationLabel extends ZeldaObject {
  LocationLabel(super.botWMarker);

  static Future<List<Marker>> findPointMarkers({
    OnMarkerPressed onPressed,
    required String markerCategoryId,
    required MapType mapType,
    required double opacity,
    required double zoom,
    required double visibleZoom,
    double fontSize = 24.0,
  }) async {
    var allShrineList = await BotWMarksFile.findLabelMarkers([markerCategoryId],
        markerImage: (botWMarker) {
          if (botWMarker.mapId != mapType.mapId) {
            return null;
          } else {
            var isValid = zoom.floorToDouble() >= visibleZoom;
            // if (botWMarker.mapId == MapType.sky.mapId) {
            //   isValid = true;
            // } else if (botWMarker.mapId == MapType.ground.mapId) {
            //   isValid = true;
            // } else if (botWMarker.mapId == MapType.underground.mapId) {
            //   isValid = true;
            // }

            if (isValid) {
              return Opacity(
                opacity: opacity,
                child: TextStyleUtil.textViewWithBorder(botWMarker.name,fontSize: fontSize),


                // Container(
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(4),
                //     child:
                //         Text(botWMarker.name, style: DialogUtil.textStyle02()),
                //   ),
                // ),
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

class RegionLabel extends LocationLabel {
  RegionLabel(super.botWMarker);

  static Future<List<Marker>> findPointMarkers({
    OnMarkerPressed onPressed,
    required MapType mapType,
    required double opacity,
    required double zoom,
  }) async {
    return LocationLabel.findPointMarkers(
      markerCategoryId: '2163',
      mapType: mapType,
      opacity: opacity,
      zoom: zoom,
      visibleZoom: 2,
    );
  }
}

class AreaLabel extends LocationLabel {
  AreaLabel(super.botWMarker);

  static Future<List<Marker>> findPointMarkers({
    OnMarkerPressed onPressed,
    required MapType mapType,
    required double opacity,
    required double zoom,
  }) async {
    return LocationLabel.findPointMarkers(
      markerCategoryId: '2164',
      mapType: mapType,
      opacity: opacity,
      zoom: zoom,
      visibleZoom: 3,
      fontSize: 20,
    );
  }
}

class PlacesLabel extends LocationLabel {
  PlacesLabel(super.botWMarker);

  static Future<List<Marker>> findPointMarkers({
    OnMarkerPressed onPressed,
    required MapType mapType,
    required double opacity,
    required double zoom,
  }) async {
    return LocationLabel.findPointMarkers(
      markerCategoryId: '2165',
      mapType: mapType,
      opacity: opacity,
      zoom: zoom,
      visibleZoom: 5,//3,
      fontSize: 18,
    );
  }
}
