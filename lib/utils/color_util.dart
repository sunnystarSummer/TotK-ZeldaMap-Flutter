import 'package:flutter/cupertino.dart';

class ColorUtil{
  static List<Color> generateRainbowColors(int count) {
    double step = 360.0 / count;
    List<Color> colors = [];
    for (int i = 0; i < count; i++) {
      double hue = (i * step) % 360;
      colors.add(HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor());
    }
    return colors;
  }
}