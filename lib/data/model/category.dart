import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';


part 'category.g.dart';

@JsonSerializable()
class Category {
  String id;
  String? parentId;
  String name;
  String checked;
  String img;
  String color;
  String markerCategoryTypeId;
  String visibleZoom;

  Category(this.id, this.parentId, this.name, this.checked, this.img,
      this.color, this.markerCategoryTypeId, this.visibleZoom);

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}