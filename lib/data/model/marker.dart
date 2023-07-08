import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marker.g.dart';

//flutter pub run build_runner watch --delete-conflicting-outputs
@JsonSerializable()
class BotWMarker {
  String id;
  String mapId;
  String submapId;
  String? overlayId;
  String markerCategoryId;
  String markerCategoryTypeId;
  String userId;
  String userName;
  String name;
  String description;
  String x;
  String y;
  String jumpMakerId;
  String tabId;
  String tabTitle;
  String tabText;
  String tabUserId;
  String tabUserName;
  String globalMarker;
  String visible;

  BotWMarker(
      this.id,
      this.mapId,
      this.submapId,
      this.overlayId,
      this.markerCategoryId,
      this.markerCategoryTypeId,
      this.userId,
      this.userName,
      this.name,
      this.description,
      this.x,
      this.y,
      this.jumpMakerId,
      this.tabId,
      this.tabTitle,
      this.tabText,
      this.tabUserId,
      this.tabUserName,
      this.globalMarker,
      this.visible);

  factory BotWMarker.fromJson(Map<String, dynamic> json) =>
      _$BotWMarkerFromJson(json);

  Map<String, dynamic> toJson() => _$BotWMarkerToJson(this);
}
