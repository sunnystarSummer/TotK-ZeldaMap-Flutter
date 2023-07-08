import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../data/json_file/category_file.dart';
import '../../data/model/category.dart';
import '../../data/model/marker.dart';
import '../../utils/parse_lat_lng_util.dart';
import '../base/zelda_object.dart';

class KorokSeed extends ZeldaObject {
  KorokSeed(super.botWMarker);

  @override
  String markerCategoryId = '';
}

class KorokSeedFile {
  static Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/BotW/markers/korok_seeds.json');
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

  static Future<List<Marker>> findMarkers(List<String> categoryIdList,
      {double zoom = 2,
      Widget? image,
      required void Function(
              BuildContext, Category, BotWMarker, List<BotWMarker>)?
          onPressed}) async {
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

        var mapMarker = Marker(
          width: 48,
          height: 48,
          point: ParseLatLngUtil.parseCrsSimpleToEPSG3857(
              double.parse(botWMarker.x), double.parse(botWMarker.y)),
          builder: (context) => IconButton(
            onPressed: () {
              onPressed!
                  .call(context, matchingCategory, botWMarker, botWMarkerList);
            },
            icon: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(int.parse(
                        matchingCategory.color.replaceAll('#', ''),
                        radix: 16))
                    .withAlpha(255), // 設定背景顏色
                shape: BoxShape.circle, // 設定形狀為圓形
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: image,
              ),
            ),
            // 設定Icon
          ),
        );
        list.add(mapMarker);
      } catch (e) {
        //
      }
    }

    return Future.value(list);
  }

  static Future<List<Marker>> findKorokSeeds(
      {required void Function(
              BuildContext, Category, BotWMarker, List<BotWMarker>)?
          onPressed,
      double zoom = 2}) async {
    return findMarkers(
      ['1916'],
      image: Image.asset('assets/BotW/icon/mapicon_korok.png'),
      onPressed: (context, category, botWMarker, botWMarkerList) {
        onPressed?.call(context, category, botWMarker, botWMarkerList);
        // var positionX = double.parse(botWMarker.x).toStringAsFixed(3);
        // var positionY = double.parse(botWMarker.y).toStringAsFixed(3);
        //
        // StringBuffer stringBuffer = StringBuffer();
        // stringBuffer.writeln('CategoryName:${category.name}');
        // stringBuffer.writeln('MarkerName:${botWMarker.name}');
        // stringBuffer.writeln('MarkerXY:$positionX,$positionY');
        // String msg = stringBuffer.toString();
        // DialogUtil.showInfoDialog(context: context, message: msg);
      },
    );
  }
}
