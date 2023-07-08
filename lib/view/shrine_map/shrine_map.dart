import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:map_of_zelda/utils/calculate_util.dart';
import 'package:map_of_zelda/utils/color_util.dart';
import 'package:map_of_zelda/utils/dialog_util.dart';
import 'package:map_of_zelda/utils/parse_lat_lng_util.dart';

import '../../component/text_view.dart';
import '../../objects/building/tower.dart';
import '../base/totk_map.dart';
import '../../../data/model/marker.dart';
import '../../../objects/building/shrine.dart';

class ShrineMapView extends StatefulWidget {
  static const String route = '/map/shrine';

  const ShrineMapView({super.key});

  @override
  State<ShrineMapView> createState() => _MapPage();
}

class _MapPage extends TotKMapState<ShrineMapView> {
  bool isShowNearShrines = false;
  List<Shrine> nearbyAndLocalShrines = [];

  //最短路徑以訪問所有神廟
  bool isShowTravelingShrines = false;
  List<Shrine> travelingShrines = [];

  @override
  List<Widget> childrenOfMapLayers() {
    return [
      //神廟
      Visibility(
        visible: true,
        child: FutureBuilder(
            future: Shrine.findPointMarkers(
                mapType: mapType,
                zoom: mapZoom(),
                opacity: calculateLogValueSky(mapType),
                onPressed: (context, category, botWMarker, botWMarkerList) {
                  //全部的神廟
                  List<Shrine> shrineList = <Shrine>[];
                  botWMarkerList.asMap().forEach((key, value) {
                    Shrine shrine = Shrine(value);
                    shrineList.add(shrine);
                  });
                  Shrine localShrine = Shrine(botWMarker);

                  // setState(() {
                  //   travelingShrines = CalculateUtil.travelingSalesmanProblem(
                  //       shrineList, localShrine);
                  //   isShowTravelingShrines = true;
                  //
                  // });
                  setState(() {
                    StringBuffer stringBuffer = StringBuffer();

                    isShowNearShrines = true;
                    nearbyAndLocalShrines = [];
                    nearbyAndLocalShrines = localShrine
                        .findNeighbors(shrineList, isSelfContainedInList: true);
                    stringBuffer.writeln(localShrine.name());
                    stringBuffer.writeln(localShrine.coord());
                    //stringBuffer.writeln(localShrine.getPoint().toString());

                    stringBuffer.writeln();
                    stringBuffer.writeln('NearShrines');
                    nearbyAndLocalShrines.asMap().forEach((key, value) {
                      if (key != 0) {
                        stringBuffer.writeln('$key. ${value.name()}');
                      }
                    });

                    String msg = stringBuffer.toString();
                    DialogUtil.showInfoDialog(
                        context: context,
                        message: msg,
                        onOkPressed: () {
                          setState(() {
                            isShowNearShrines = false;
                            isShowTravelingShrines = false;
                          });
                        });
                  });
                }),
            builder: (context, snap) {
              if (snap.hasData) {
                final markers = snap.requireData;

                return MarkerLayer(
                  markers: markers,
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      //鄰近的神廟
      Visibility(
        visible: isShowNearShrines,
        child: FutureBuilder(
            future: Future.value(nearbyAndLocalShrines),
            builder: (context, snap) {
              if (snap.hasData) {
                final shrines = snap.requireData;
                final localShrine = shrines[0];
                final neighborhoodShrines = <Shrine>[...shrines];
                neighborhoodShrines.removeAt(0);

                CalculateUtil.travelingSalesmanProblem(
                    neighborhoodShrines, localShrine);

                final botWMarkers = <BotWMarker>[];
                shrines.asMap().forEach((key, value) {
                  botWMarkers.add(value.botWMarker);
                });

                final colorList =
                    ColorUtil.generateRainbowColors(shrines.length);

                final markers = <Marker>[];
                botWMarkers.asMap().forEach((key, botWMarkers) {
                  final color = colorList[key % colorList.length];
                  markers.add(Marker(
                    width: 56, //48,
                    height: 56, //48,
                    point: ParseLatLngUtil.parseCrsSimpleToEPSG3857(
                        double.parse(botWMarkers.x),
                        double.parse(botWMarkers.y)),
                    builder: (context) => IconButton(
                      onPressed: () {},
                      icon: Container(
                        width: 56, //48,
                        height: 56, //48,
                        decoration: BoxDecoration(
                          color: color, // 設定背景顏色
                          shape: BoxShape.circle, // 設定形狀為圓形
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              '$key',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      // 設定Icon
                    ),
                  ));
                });

                return MarkerLayer(
                  markers: markers,
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      //訪問神社路徑
      Visibility(
        visible: isShowTravelingShrines,
        child: FutureBuilder(
            future: Future.value(travelingShrines),
            builder: (context, snap) {
              if (snap.hasData) {
                final shrines = snap.requireData;
                final localShrine = shrines[0];
                final neighborhoodShrines = <Shrine>[...shrines];
                neighborhoodShrines.removeAt(0);

                final botWMarkers = <BotWMarker>[];
                shrines.asMap().forEach((key, value) {
                  botWMarkers.add(value.botWMarker);
                });

                final colorList =
                    ColorUtil.generateRainbowColors(shrines.length);

                final markers = <Marker>[];
                botWMarkers.asMap().forEach((key, botWMarkers) {
                  final color = colorList[key % colorList.length];
                  markers.add(Marker(
                    width: 56,
                    height: 56,
                    point: ParseLatLngUtil.parseCrsSimpleToEPSG3857(
                        double.parse(botWMarkers.x),
                        double.parse(botWMarkers.y)),
                    builder: (context) => IconButton(
                      onPressed: () {
                        setState(() {
                          isShowTravelingShrines = false;
                        });
                      },
                      icon: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color, // 設定背景顏色
                          shape: BoxShape.circle, // 設定形狀為圓形
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Center(
                            child: Text(
                              '$key',
                              textAlign: TextAlign.center,
                              style: TextStyleUtil.textStyleRockNRoll(),
                            ),
                          ),
                        ),
                      ),
                      // 設定Icon
                    ),
                  ));
                });

                return MarkerLayer(
                  markers: markers,
                );
              }
              return const SizedBox.shrink();
            }),
      ),
      //塔
      Visibility(
        visible: false,
        child: FutureBuilder(
            future: Tower.findPointMarkers(
                zoom: mapZoom(),
                onPressed: (context, category, botWMarker, botWMarkerList) {
                  setState(() {
                    StringBuffer stringBuffer = StringBuffer();

                    Tower tower = Tower(botWMarker);
                    stringBuffer.writeln(tower.name());
                    stringBuffer.writeln(tower.coord());

                    // JsonEncoder encoder = const JsonEncoder.withIndent('  ');
                    // String prettyprint = encoder.convert(botWMarker.toJson());
                    // stringBuffer.writeln(prettyprint);

                    String msg = stringBuffer.toString();
                    DialogUtil.showInfoDialog(
                        context: context, message: msg, onOkPressed: () {});
                  });
                }),
            builder: (context, snap) {
              if (snap.hasData) {
                final markers = snap.requireData;

                return MarkerLayer(
                  markers: markers,
                );
              }
              return const SizedBox.shrink();
            }),
      ),

      //尋找物品
      Align(
        alignment: Alignment.bottomLeft,
        child: Visibility(
          visible: false,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white60,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Search：'),
                      SizedBox(
                        width: 150,
                        child: TextField(controller: zoomController),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
