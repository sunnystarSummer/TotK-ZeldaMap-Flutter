import 'dart:convert';

class JsonUtil{
  static String prettyJson(dynamic json) {
    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}