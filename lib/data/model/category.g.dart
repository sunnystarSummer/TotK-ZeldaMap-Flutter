// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      json['id'] as String,
      json['parentId'] as String?,
      json['name'] as String,
      json['checked'] as String,
      json['img'] as String,
      json['color'] as String,
      json['markerCategoryTypeId'] as String,
      json['visibleZoom'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'name': instance.name,
      'checked': instance.checked,
      'img': instance.img,
      'color': instance.color,
      'markerCategoryTypeId': instance.markerCategoryTypeId,
      'visibleZoom': instance.visibleZoom,
    };
