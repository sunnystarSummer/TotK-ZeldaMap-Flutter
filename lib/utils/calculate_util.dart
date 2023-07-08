import 'package:flutter_map/flutter_map.dart';

import '../objects/base/zelda_object.dart';

class CalculateUtil {
// 計算神廟的方圓值
  static List<double> calculateRadius(List<CustomPoint> templesPosition) {
    // 計算每個神廟的方圓值
    List<double> radii = [];
    for (int i = 0; i < templesPosition.length; i++) {
      double radius = 0;
      for (int j = 0; j < templesPosition.length; j++) {
        final temple01 = templesPosition[i];
        final temple02 = templesPosition[j];
        double dist = temple01.distanceTo(temple02);
        if (dist > radius) {
          radius = dist;
        }
      }
      radii.add(radius);
    }

    // 使用貪婪演算法來將方圓的重疊部分最小化
    List<double> overlaps = [];
    for (int i = 0; i < templesPosition.length; i++) {
      double overlap = 0;
      for (int j = 0; j < templesPosition.length; j++) {
        if (i != j) {
          final temple01 = templesPosition[i];
          final temple02 = templesPosition[j];
          double dist = temple01.distanceTo(temple02);
          double combinedRadius = radii[i] + radii[j];
          if (dist < combinedRadius) {
            overlap += (combinedRadius - dist) / 2;
          }
        }
      }
      overlaps.add(overlap);
    }

    List<double> list = [];
    // 輸出每個神廟的方圓值
    for (int i = 0; i < templesPosition.length; i++) {
      double radius = radii[i] - overlaps[i];
      print('神廟${i + 1}的方圓值為$radius');
      list.add(radius);
    }
    return list;
  }

  static List<T> travelingSalesmanProblem<T extends ZeldaObject>(List<T> templeList, T start) {
    final list = <T>[];

    const indexOfStartShrine = 0; // 起始神廟索引為 0
    final templeCount = templeList.length;

    // 貪婪法求解 TSP 問題
    final visited = List<bool>.filled(templeCount, false);
    visited[indexOfStartShrine] = true;

    final solution = List<T?>.filled(templeCount, null);
    solution[0] = start;

    var currentShrine =  start;
    for (var i = 1; i < templeCount; i++) {
      var indexNearestTemple = -1;
      T? nearestTemple;
      var nearestDistance = double.infinity;

      for (var j = 0; j < templeCount; j++) {
        var endObject = templeList[j];
        ZeldaObjectsBetween objectsBetween = ZeldaObjectsBetween<T>(currentShrine, endObject);

        final value = objectsBetween.distance();
        if (!visited[j] && value < nearestDistance) {
          nearestTemple = objectsBetween.endObject as T?;
          indexNearestTemple = j;
          nearestDistance = value;
        }
      }

      solution[i] = nearestTemple;
      visited[indexNearestTemple] = true;
      currentShrine = templeList[indexNearestTemple];
    }

    solution.asMap().forEach((key, value) {
      if(value!=null){
        list.add(value);
      }
    });

    return list;
  }

}
