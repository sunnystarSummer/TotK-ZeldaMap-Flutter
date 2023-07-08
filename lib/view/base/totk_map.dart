import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_of_zelda/view/base/zelda_map.dart';

import '../../objects/map/map_type.dart';
import '../../utils/parse_lat_lng_util.dart';

abstract class TotKMapState<T extends StatefulWidget> extends ZeldaMapState<T> {
  @override
  LatLng center() {
    return ParseLatLngUtil.parseCrsSimpleToEPSG3857(378.665, -1335.99);
  }

  double calculateLogValueSky(MapType locationType) {
    const levelMax = 100.0;
    const level02 = 66.0;
    const level01 = 33.0;
    const levelMin = 0.0;

    isShowSky = true;
    isShowSurface = true;
    isShowDepths = true;
    if (level02 < heightValue) {
      isShowDepths = false;

    } else if (level01 <= heightValue && heightValue <= level02) {

      if (nextHeightValue != 0) {
        final subValue = nextHeightValue - heightValue;
        if (subValue > 0) {
          isShowDepths = false;
        } else if (subValue < 0) {
          isShowSky = false;
        }
      }
    } else if (heightValue < level01) {
      isShowSky = false;

    }

    nextHeightValue = heightValue;

    switch (locationType) {
      case MapType.sky:
        if (level02 < heightValue) {
          mapType = MapType.sky;

          const double startHeight = levelMax;
          const double endHeight = level02;
          const double startValue = 1.0;
          const double endValue = 0.0;
          double logValue =
              (heightValue - endHeight) / (startHeight - endHeight);

          return endValue + (startValue - endValue) * (logValue);
        } else {
          mapType = MapType.surface;
        }
        return 0;
      case MapType.surface:
        if (level02 < heightValue) {
          mapType = MapType.sky;

          const double startHeight = levelMax;
          const double endHeight = level02;
          const double startValue = 1.0;
          const double endValue = 1.0;

          double logValue =
              (heightValue - endHeight) / (startHeight - endHeight);
          return endValue + (startValue - endValue) * (logValue);
        } else if (level01 <= heightValue && heightValue <= level02) {
          mapType = MapType.surface;

          return 1;
        } else if (heightValue < level01) {
          mapType = MapType.depths;

          const double startHeight = level01;
          const double endHeight = levelMin;
          const double startValue = 1.0;
          const double endValue = 0.0;

          double logValue =
              (heightValue - endHeight) / (startHeight - endHeight);
          return endValue + (startValue - endValue) * (logValue);
        }

        return 0;
      case MapType.depths:
        if (heightValue < level01) {
          mapType = MapType.depths;

          const double startHeight = level01;
          const double endHeight = levelMin;
          const double startValue = 1.0;
          const double endValue = 1.0;

          double logValue =
              (heightValue - endHeight) / (startHeight - endHeight);
          return endValue + (startValue - endValue) * (logValue);
        }

        return 0;
    }
  }

  @override
  List<Widget> tileLayers() {
    var subdomains = ["zeldamaps.com"];

    bool isAssets = false;
    //bool isAssets = true;
    var baseUrlTemplate = 'https://{s}/tiles/totk/hyrule';
    if (isAssets) {
      baseUrlTemplate = 'assets/TotK/map/Hyrule';
    }

    return <Widget>[
      Visibility(
        visible: isShowDepths,
        child: TileLayer(
          subdomains: subdomains,
          opacity: calculateLogValueSky(MapType.depths),
          backgroundColor: const Color(0xFF0a0c0a),
          tileProvider: isAssets ? AssetTileProvider() : null,
          maxZoom: maxZoom,
          urlTemplate: ExtensionMapType.urlTemplate(
              MapType.depths, baseUrlTemplate),
          tileBounds: LatLngBounds(LatLng(-90, -180), LatLng(90, 180)),
        ),
      ),
      Visibility(
        visible: isShowSurface,
        child: TileLayer(
          subdomains: subdomains,
          opacity: calculateLogValueSky(MapType.surface),
          backgroundColor: const Color(0xFF0a0c0a),
          tileProvider: isAssets ? AssetTileProvider() : null,
          maxZoom: maxZoom,
          urlTemplate:
              ExtensionMapType.urlTemplate(MapType.surface, baseUrlTemplate),
          tileBounds: LatLngBounds(LatLng(-90, -180), LatLng(90, 180)),
        ),
      ),
      Visibility(
        visible: isShowSky,
        child: TileLayer(
          subdomains: subdomains,
          opacity: calculateLogValueSky(MapType.sky),
          backgroundColor: const Color(0xFF0a0c0a),
          tileProvider: isAssets ? AssetTileProvider() : null,
          maxZoom: maxZoom,
          urlTemplate:
              ExtensionMapType.urlTemplate(MapType.sky, baseUrlTemplate),
          tileBounds: LatLngBounds(LatLng(-90, -180), LatLng(90, 180)),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    // positionXController.text = center()!.latitude.toString();
    // positionYController.text = center()!.longitude.toString();

    final centerLocation = center();
    print("centerWithEPSG3857: $centerLocation");

    final location = ParseLatLngUtil.parseEPSG3857ToCrsSimple(
        centerLocation.latitude, centerLocation.longitude);
    print("centerWithCrsSimple: $location");

    positionXController.text = location.x.toStringAsFixed(0);
    positionYController.text = location.y.toStringAsFixed(0);

    var boundTop = ParseLatLngUtil.parseCrsSimpleToEPSG3857(7000, -8000);
    var boundBottom = ParseLatLngUtil.parseCrsSimpleToEPSG3857(-7000, 8000);
    print("boundTop: $boundTop");
    print("boundBottom: $boundBottom");

    bounds = LatLngBounds(boundTop, boundBottom);
    maxZoom = 8;
    heightValue = 50;
    zoomController.text = '$zoom';
  }
}
