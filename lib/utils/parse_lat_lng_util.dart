import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../simple_crs.dart';
import '../zelda_crs.dart';

class ParseLatLngUtil{

  static LatLng parseCrsSimpleToEPSG3857(double lat,double lng,{double zoom =1}){
    final newPoint = ZeldaCrsSimple().latLngToTransformedPoint(CustomPoint(lat, lng), zoom);
    final newLatLng = ZeldaEpsg3857().pointToLatLng(newPoint, zoom);
    return newLatLng!;
  }

  static CustomPoint parseEPSG3857ToCrsSimple(double lat,double lng,{double zoom =1}){
    final newPoint = ZeldaEpsg3857().latLngToPoint(LatLng(lat, lng), zoom);
    final newLatLng = ZeldaCrsSimple().pointToUntransformedLatLng(newPoint, zoom);
    return newLatLng;
  }
}