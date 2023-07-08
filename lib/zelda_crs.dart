import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class ZeldaEpsg3857 extends Epsg3857 {

  @override
  final String code = 'ZELDA.EPSG.3857 ';

  @override
  bool get infinite => true;

  double distance(LatLng latlng1, LatLng latlng2) {
    var dx = latlng2.longitude - latlng1.longitude,
        dy = latlng2.latitude - latlng1.latitude;

    return math.sqrt(dx * dx + dy * dy);
  }

  CustomPoint pointToUntransformedLatLng(CustomPoint point, double zoom) {
    final scale = this.scale(zoom);
    final untransformedPoint =
        transformation.untransform(point, scale.toDouble());
    return untransformedPoint;
  }

  CustomPoint latLngToTransformedPoint(CustomPoint point, double zoom) {
    final scale = this.scale(zoom);
    return transformation.transform(point, scale.toDouble());
  }
}
