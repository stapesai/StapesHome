class FavDevicesModel {
  final String id;
  final String entityId;

  FavDevicesModel({
    required this.entityId,
    required this.id,
  });
  factory FavDevicesModel.fromJson(Map<String, dynamic> json) {
    return FavDevicesModel(
      entityId: json['entityid'],
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
      'entityid': entityId,
      'id': id,
    };
  }
}
