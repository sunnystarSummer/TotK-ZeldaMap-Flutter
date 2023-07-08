import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';

import '../../utils/parse_lat_lng_util.dart';
import '../model/category.dart';
import '../model/marker.dart';

import 'category_file.dart';
import 'dart:convert' show json;

typedef OnMarkerPressed = void Function(
    BuildContext, Category, BotWMarker, List<BotWMarker>)?;
typedef MarkerImage = Widget? Function(BotWMarker botWMarker);

class BotWMarksFile {
  static Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/TotK/markers/markers.json');
  }

  static Future<List<Marker>> findMarkers(
    List<String> categoryIdList, {
    double zoom = 2,
    MarkerImage? markerImage,
    OnMarkerPressed onPressed,
  }) async {
    String jsonString = await loadAsset();
    List<dynamic> markers = json.decode(jsonString);

    List<Category> categories = await CategoryFile.getCategories();
    List<Category> categoryList = categories
        .where((element) => categoryIdList.contains(element.id))
        .toList();

    List<BotWMarker> botWMarkerList = await findBotWMarkers(categoryIdList);

    List<Marker> list = <Marker>[];
    for (final botWMarker in botWMarkerList) {
      try {
        var matchingCategory = categoryList.firstWhere(
            (category) => botWMarker.markerCategoryId == category.id);

        if (markerImage != null) {
          Marker mapMarker;
          Widget? childWidget = markerImage(botWMarker);

          if (childWidget != null) {
            mapMarker = Marker(
              width: 56, //48,
              height: 56, //48,
              point: ParseLatLngUtil.parseCrsSimpleToEPSG3857(
                  double.parse(botWMarker.x), double.parse(botWMarker.y)),
              builder: (context) => IconButton(
                onPressed: () {
                  onPressed!.call(
                      context, matchingCategory, botWMarker, botWMarkerList);
                },
                icon: childWidget,
                // 設定Icon
              ),
            );
            list.add(mapMarker);
          }

        }
      } catch (e) {
        //
      }
    }

    return Future.value(list);
  }

  static Future<List<Marker>> findLabelMarkers(
    List<String> categoryIdList, {
    double zoom = 2,
    MarkerImage? markerImage,
    OnMarkerPressed onPressed,
  }) async {
    String jsonString = await loadAsset();
    List<dynamic> markers = json.decode(jsonString);

    List<Category> categories = await CategoryFile.getCategories();
    List<Category> categoryList = categories
        .where((element) => categoryIdList.contains(element.id))
        .toList();

    List<BotWMarker> botWMarkerList = await findBotWMarkers(categoryIdList);

    List<Marker> list = <Marker>[];
    for (final botWMarker in botWMarkerList) {
      try {
        var matchingCategory = categoryList.firstWhere(
            (category) => botWMarker.markerCategoryId == category.id);

        if (markerImage != null) {
          Marker mapMarker;
          Widget? childWidget = markerImage(botWMarker);

          if (childWidget != null) {
            mapMarker = Marker(
              width: 250, //48,
              height: 250, //48,
              point: ParseLatLngUtil.parseCrsSimpleToEPSG3857(
                  double.parse(botWMarker.x), double.parse(botWMarker.y)),
              builder: (context) => IconButton(
                  onPressed: () {
                    onPressed!.call(
                        context, matchingCategory, botWMarker, botWMarkerList);
                  },
                  icon: childWidget
                  // 設定Icon
                  ),
            );
            list.add(mapMarker);
          }
        }
      } catch (e) {
        //
      }
    }

    return Future.value(list);
  }

  static Future<List<BotWMarker>> findBotWMarkers(
      List<String> categoryIdList) async {
    String jsonString = await loadAsset();
    List<dynamic> markers = json.decode(jsonString);

    List<Category> categories = await CategoryFile.getCategories();
    List<Category> categoryList = categories
        .where((element) => categoryIdList.contains(element.id))
        .toList();

    List<BotWMarker> botWMarkerList = <BotWMarker>[];
    markers.asMap().forEach((key, value) {
      final botWMarker = BotWMarker.fromJson(value);
      try {
        var matchingCategory = categoryList.firstWhere(
            (category) => botWMarker.markerCategoryId == category.id);
        botWMarkerList.add(botWMarker);
      } catch (e) {
        //
      }
    });
    return Future.value(botWMarkerList);
  }
}
