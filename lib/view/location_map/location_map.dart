import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import '../../objects/location/location.dart';
import '../base/totk_map.dart';

class LocationMapView extends StatefulWidget {
  static const String route = '/map/location';

  const LocationMapView({super.key});

  @override
  State<LocationMapView> createState() => _MapPage();
}

class _MapPage extends TotKMapState<LocationMapView> {
  @override
  List<Widget> childrenOfMapLayers() {
    return [
      //地域
      Visibility(
        visible: true,
        child: FutureBuilder(
            future: RegionLabel.findPointMarkers(
              opacity: calculateLogValueSky(mapType),
              zoom: mapZoom(),
              mapType: mapType,
              onPressed: (context, category, botWMarker, botWMarkerList) {},
            ),
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
      //地區
      Visibility(
        visible: true,
        child: FutureBuilder(
            future: AreaLabel.findPointMarkers(
              opacity: calculateLogValueSky(mapType),
              zoom: mapZoom(),
              mapType: mapType,
              onPressed: (context, category, botWMarker, botWMarkerList) {},
            ),
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
      //地方
      Visibility(
        visible: true,
        child: FutureBuilder(
            future: PlacesLabel.findPointMarkers(
              opacity: calculateLogValueSky(mapType),
              zoom: mapZoom(),
              mapType: mapType,
              onPressed: (context, category, botWMarker, botWMarkerList) {},
            ),
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
    ];
  }
}
