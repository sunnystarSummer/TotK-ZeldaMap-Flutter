import 'package:flutter/cupertino.dart';

class TextStyleUtil{

  static TextStyle textStyleSheIKah() {
    return const TextStyle(
      //fontWeight: FontWeight.bold,
      //fontFamily: 'Seal_Script',
      fontFamily: 'BotW_Sheikah',
      height: 1.2,
    );
  }

  static TextStyle textStyleRockNRoll() {
    //25
    return const TextStyle(
      //fontWeight: FontWeight.bold,
      //fontFamily: 'Seal_Script',
      fontFamily: 'RocknRollOne-Regular',
    );
  }

  static Widget textViewWithBorder(String text,{double fontSize = 24.0}) {

    //25
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = const Color.fromARGB(255,144,126,78),
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: const Color.fromARGB(255,230,223,170),
          ),
        ),
      ],
    );
  }
}