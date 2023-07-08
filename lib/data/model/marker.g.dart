// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BotWMarker _$BotWMarkerFromJson(Map<String, dynamic> json) => BotWMarker(
      json['id'] as String,
      json['mapId'] as String,
      json['submapId'] as String,
      json['overlayId'] as String?,
      json['markerCategoryId'] as String,
      json['markerCategoryTypeId'] as String,
      json['userId'] as String,
      json['userName'] as String,
      json['name'] as String,
      json['description'] as String,
      json['x'] as String,
      json['y'] as String,
      json['jumpMakerId'] as String,
      json['tabId'] as String,
      json['tabTitle'] as String,
      json['tabText'] as String,
      json['tabUserId'] as String,
      json['tabUserName'] as String,
      json['globalMarker'] as String,
      json['visible'] as String,
    );

Map<String, dynamic> _$BotWMarkerToJson(BotWMarker instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mapId': instance.mapId,
      'submapId': instance.submapId,
      'overlayId': instance.overlayId,
      'markerCategoryId': instance.markerCategoryId,
      'markerCategoryTypeId': instance.markerCategoryTypeId,
      'userId': instance.userId,
      'userName': instance.userName,
      'name': instance.name,
      'description': instance.description,
      'x': instance.x,
      'y': instance.y,
      'jumpMakerId': instance.jumpMakerId,
      'tabId': instance.tabId,
      'tabTitle': instance.tabTitle,
      'tabText': instance.tabText,
      'tabUserId': instance.tabUserId,
      'tabUserName': instance.tabUserName,
      'globalMarker': instance.globalMarker,
      'visible': instance.visible,
    };
