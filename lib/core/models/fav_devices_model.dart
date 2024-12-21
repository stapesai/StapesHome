class FavDevicesModel {
  final String id;
  final String entityId;

  FavDevicesModel({
    required this.entityId,
    required this.id,
  });
  factory FavDevicesModel.fromJson(Map<String, dynamic> json) {
    return FavDevicesModel(
      entityId: json['entity_id'],
      id: json['id'],
    );
  }

  // Object toJson() {
  //   return jsonEncode({
  //     'entityid': entityId,
  //     'id': id,
  //   });
  // }

  Map<String, dynamic> toMap() {
    return {
      'entity_id': entityId,
      'id': id,
    };
  }
}
