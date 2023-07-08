import 'package:flutter/services.dart';

import '../model/category.dart';

import 'dart:convert';

class CategoryFile {

  static Future<String> loadAsset() async {
        return await rootBundle.loadString('assets/TotK/categories/categories.json');
  }

  static Future<List<Category>> getCategories() async {
    String jsonString = await loadAsset();
    List<dynamic> map = json.decode(jsonString);

    List<Category> list = <Category>[];
    for(Map<String,dynamic> data in map){
      list.add(Category.fromJson(data));
    }
    return Future.value(list);
  }
}