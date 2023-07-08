import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_of_zelda/utils/parse_lat_lng_util.dart';
import 'package:map_of_zelda/zelda_crs.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../objects/map/map_type.dart';

abstract class ZeldaMapState<T extends StatefulWidget> extends State<T> {
  LatLng center();

  List<Widget> childrenOfMapLayers();

  List<Widget> tileLayers();

  MapType mapType = MapType.sky;
  double heightValue = 0;
  double nextHeightValue = 0;
  var isShowDepths = true;
  var isShowSurface = true;
  var isShowSky = true;

  double maxZoom = 7;
  double zoom = 4;
  LatLngBounds bounds = LatLngBounds(LatLng(-90, -180), LatLng(90, 180));
  var mapController = MapController();
  TextEditingController positionXController = TextEditingController();
  TextEditingController positionYController = TextEditingController();
  TextEditingController zoomController = TextEditingController();

  double mapZoom() {
    return double.parse(zoomController.text);
  }

  @override
  Widget build(BuildContext context) {
    var zeldaCrs = ZeldaEpsg3857();

    return Scaffold(
      //appBar: AppBar(title: const Text('ZELDA MAP')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              scrollWheelVelocity: 0.00125,
              center: center(),
              crs: zeldaCrs,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              minZoom: 1,
              zoom: mapZoom(),
              maxZoom: maxZoom,
              onTap: (pTapPosition, pLatLng) {
                tapUpdate(pTapPosition, pLatLng);
              },
              onMapEvent: (event) {
                eventUpdate(event);
              },
              maxBounds: bounds,
            ),
            children: tileLayers() + childrenOfMapLayers(),
          ),
          //上方Bar
          //SafeArea(child: functionLayer()),
          Visibility(
            visible: false,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white70,
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top,
              ),
              child: functionLayer(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 400,
                  child: SfSlider.vertical(
                    min: 0.0,
                    max: 100.0,
                    value: heightValue,
                    interval: 10,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 1,
                    onChanged: (dynamic value) {
                      setState(() {
                        heightValue = value;

                        if (false) {
                          const double minHeight = 0.0;
                          const double maxHeight = 100.0;
                          double minZoom = 3.0;
                          double maxZoom = 3.5;

                          double normalizedHeight = (heightValue - minHeight) /
                              (maxHeight - minHeight);
                          double zoom = mapController.zoom;
                          if (55 < heightValue) {
                            zoom = minZoom +
                                (maxZoom - minZoom) * normalizedHeight;
                            zoom = (maxZoom + minZoom) - zoom;
                          } else if (45 < heightValue) {
                            zoom = mapController.zoom;
                          } else {
                            zoom = minZoom +
                                (maxZoom - minZoom) * normalizedHeight;
                            zoom = (maxZoom + minZoom) - zoom;
                          }

                          mapController.move(mapController.center, zoom);
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 56, //160,
                  //height: 100,
                  child: Column(children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          mapType = MapType.sky;
                          heightValue = 100;

                          isShowSky = true;
                          isShowSurface = false;
                          isShowDepths = false;
                        });
                      },
                      child: //const Text('Sky')
                          const Image(
                        image: AssetImage('assets/TotK/icon/locations/sky.png'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          mapType = MapType.surface;
                          heightValue = 50;

                          isShowSky = false;
                          isShowSurface = true;
                          isShowDepths = false;
                        });
                      },
                      child: //const Text('Surface')
                          const Image(
                        image: AssetImage(
                            'assets/TotK/icon/locations/surface.png'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          mapType = MapType.depths;
                          heightValue = 0;

                          isShowSky = false;
                          isShowSurface = false;
                          isShowDepths = true;
                        });
                      },
                      child: //const Text('Depths')
                          const Image(
                        image:
                            AssetImage('assets/TotK/icon/locations/depths.png'),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget functionLayer() {
    return Row(
      children: [
        Row(
          children: [
            const Text('X：'),
            SizedBox(
              width: 100,
              child: TextField(controller: positionXController),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Y：'),
            SizedBox(
              width: 150,
              child: TextField(controller: positionYController),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Zoom：'),
            SizedBox(
              width: 150,
              child: TextField(controller: zoomController),
            ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       var zoomIn = mapZoom();
            //       zoomIn += 1.0;
            //       zoomIn = zoomIn > maxZoom ? maxZoom : zoomIn;
            //       zoom = zoomIn;
            //       zoomController.text = zoom.toStringAsFixed(2);
            //       mapController.move(mapController.center, zoom);
            //     });
            //   },
            //   child: const Text('ZoomIn'),
            // ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       var zoomOut = mapZoom();
            //       zoomOut -= 1.0;
            //       zoomOut = zoomOut < 1 ? 1 : zoomOut;
            //       zoom = zoomOut;
            //       zoomController.text = zoom.toStringAsFixed(2);
            //       mapController.move(mapController.center, zoom);
            //     });
            //   },
            //   child: const Text('ZoomOut'),
            // )
          ],
        ),
        TextButton(
            onPressed: () {
              setPosition(
                lat: double.parse(positionYController.text),
                lng: double.parse(positionXController.text),
                zoom: double.parse(zoomController.text),
              );
            },
            child: const Text('Set Position!')),
      ],
    );
  }

  void eventUpdate(MapEvent event) {
    setState(() {
      final lat = event.center.latitude;
      final lng = event.center.longitude;
      final location = ParseLatLngUtil.parseEPSG3857ToCrsSimple(lat, lng);

      //positionXController.text = location.x.toStringAsFixed(0);
      //positionYController.text = location.y.toStringAsFixed(0);

      zoomController.text = event.zoom.toStringAsFixed(2);
    });
  }

  void tapUpdate(pTapPosition, pLatLng) {
    print("tapUpdate");
    setState(() {
      final lat = pLatLng.latitude;
      final lng = pLatLng.longitude;
      final location = ParseLatLngUtil.parseEPSG3857ToCrsSimple(lat, lng);

      positionXController.text = location.x.toStringAsFixed(0);
      positionYController.text = location.y.toStringAsFixed(0);
    });
  }

  void setPosition(
      {isCrsSimple = true, double lat = 0, double lng = 0, double zoom = 1}) {
    setState(() {
      mapController.move(
          ParseLatLngUtil.parseCrsSimpleToEPSG3857(lat, lng), zoom);
    });
  }
}
