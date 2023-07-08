import 'package:flutter_map/flutter_map.dart';

import '../../data/model/marker.dart';

import 'dart:math';

class ZeldaObject {
  BotWMarker botWMarker;

  ZeldaObject(this.botWMarker);

  String name() => botWMarker.name;

  List<T> findNeighbors<T extends ZeldaObject>(List<T> allObjects,
      {bool isSelfContainedInList = false, int maxNeighbors = 3}) {
    List<T> neighbors = [];
    // Sort the other zeldaObjects by distance to this zeldaObject
    List<T> sortedObjects = allObjects
        .where((zeldaObject) => zeldaObject != this)
        .toList()
      ..sort((a, b) => distanceTo(a).compareTo(distanceTo(b)));

    // Add the nearest neighbors as neighbors
    if (isSelfContainedInList) {
      for (int i = 0; i < min(maxNeighbors + 1, sortedObjects.length); i++) {
        final zeldaObject = sortedObjects[i];
        neighbors.add(zeldaObject);
      }
    } else {
      for (int i = 1; i < min(maxNeighbors + 1, sortedObjects.length); i++) {
        final zeldaObject = sortedObjects[i];
        neighbors.add(zeldaObject);
      }
    }
    return neighbors;
  }

  CustomPoint getPoint() {
    return CustomPoint(double.parse(botWMarker.x), double.parse(botWMarker.y));
  }

  double distanceTo(ZeldaObject other) {
    CustomPoint point = getPoint();
    CustomPoint otherPoint = other.getPoint();
    return sqrt(
        pow(otherPoint.x - point.x, 2) + pow(otherPoint.y - point.y, 2));
  }

  final RegExp _regex = RegExp(r'-?\d+'); // 正則表達式用於匹配數字
  //座標
  String coord() {
    Iterable<RegExpMatch> matches = _regex.allMatches(botWMarker.tabText);
    String extractedText = '';
    for (RegExpMatch match in matches) {
      extractedText += '${match.group(0)!},';
    }
    extractedText = extractedText.substring(0, extractedText.length - 1);
    return extractedText;
  }

  double coordZ() {
    String text = coord().split(',').last;
    return double.parse(text);
  }
}

class ZeldaObjectsBetween<T extends ZeldaObject> {
  ZeldaObjectsBetween(this.startObject, this.endObject);

  T startObject;
  T endObject;

  double distance() {
    return startObject.getPoint().distanceTo(endObject.getPoint());
  }
}
