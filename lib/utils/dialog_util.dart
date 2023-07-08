import 'package:flutter/material.dart';

import '../component/text_view.dart';

class DialogUtil {
  static bool hasErrorInfo({required BuildContext context, required response}) {
    if (response.code != 200) {
      showInfoDialog(context: context, message: response.message);
      return true;
    }
    return false;
  }

  static void showInfoDialog(
      {required BuildContext context,
      String message = "",
      Function()? onOkPressed}) {

    final style = TextStyleUtil.textStyleRockNRoll();

    showDialog(
      barrierColor: Colors.transparent,
      context: context, //需要一個BuildContext對象
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white60,//Colors.transparent,
          title: Text('INFORMATION', style: style),
          content: IntrinsicHeight(
            child: Column(
              children: [
                // SelectableText(
                //   message,
                //   style: textStyleSheikah(),
                // ),
                SelectableText(
                  message,
                  style: style,
                ),
              ],
            ),
          ),
          //Text(message),
          actions: [
            TextButton(
              onPressed: () {
                onOkPressed?.call();
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: style,
              ),
            ),
          ],
        );
      },
    );
  }

  static void showCustomLayoutDialog(
      {required BuildContext context,
      required Widget child,
      Function()? okTap}) {
    showDialog(
      context: context, //需要一個BuildContext對象
      builder: (BuildContext context) {
        return AlertDialog(
          content: child, //Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  if (okTap != null) {
                    okTap.call();
                  }
                  Navigator.pop(context);
                },
                child: const Text('OK')),
          ],
        );
      },
    );
  }
}
