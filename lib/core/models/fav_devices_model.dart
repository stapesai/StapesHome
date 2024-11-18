import 'dart:convert';

class FavDevicesModel {
  final String entityId;
  final String id;
  final String userId;

  FavDevicesModel({
    required this.entityId,
    required this.id,
    required this.userId,
  });
    factory FavDevicesModel.fromJson(Map<String, dynamic> json) {
    return FavDevicesModel(
      entityId: json['entityid'],
      id: json['id'],
      userId: json['userId'],
    );
  }

  Object toJson() {
    return jsonEncode({
      'entityid': entityId,
      'id': id,
      'userId': userId,
    });
  }
}
