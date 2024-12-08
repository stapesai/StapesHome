// lib/features/sessions/domain/entities/session.dart

class Session {
  final String deviceName;
  final String lastActive;
  final String deviceIcon;

  Session({
    required this.deviceName,
    required this.lastActive,
    required this.deviceIcon,
  });
}