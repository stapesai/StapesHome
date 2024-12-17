import 'package:stapes_home/core/models/floor_model.dart';

class GetFloorsParams {}

class GetFloorsResponse {
  final List<FloorModel> floors;

  GetFloorsResponse({required this.floors});

  factory GetFloorsResponse.fromJson(Map<String, dynamic> json) {
    return GetFloorsResponse(
      floors: List<FloorModel>.from(json['floors'].map((x) => FloorModel.fromJson(x))),
    );
  }
}
