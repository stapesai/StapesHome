import 'package:stapes_home/features/sessions/domain/entities/sessions_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required String sessionId,
    required String deviceName,
    required String lastActive,
  }) : super(
          sessionId: sessionId,
          deviceName: deviceName,
          lastActive: lastActive,
        );

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json["id"],
      deviceName: json["device_name"] ?? "Unknown",
      lastActive: json["last_active"] ?? "N/A",
    );
  }
}