import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class ZeldaCrsSimple extends CrsSimple {
  @override
  final String code = 'ZELDA.CRS.SIMPLE';

  @override
  final Projection projection;

  @override
  final Transformation transformation;

  ZeldaCrsSimple()
      : projection = const SphericalMercator(),
        transformation =
            const Transformation(0.0117188, 70.3125, -0.0117188, 58.5938),
        super();

  @override
  bool get infinite => true;

  /// Zoom to Scale function.
  @override
  num scale(double zoom) {
    return math.pow(2, zoom);
  }

  /// Scale to Zoom function.
  @override
  double zoom(double scale) {
    return math.log(scale) / math.ln2;
  }

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