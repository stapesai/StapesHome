// lib/features/provisioning/domain/models/parse_qr_data_model.dart

import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';
import 'package:stapes_home/features/scanner/data/models/pair_tv_qr_model.dart';

enum QrCodeType { iotNode, tvPairing, unknown }

class ParseQrDataModel {
  final QrCodeType type;
  final dynamic payload;

  ParseQrDataModel({
    required this.type,
    this.payload,
  });

  factory ParseQrDataModel.fromQrString(String qrData) {
    final parts = qrData.split(';');

    if (parts.isEmpty) return ParseQrDataModel(type: QrCodeType.unknown);

    switch (parts[0]) {
      case 'IOT-NODE':
        if (parts.length == 6) {
          return ParseQrDataModel(
            type: QrCodeType.iotNode,
            payload: IotQrModel(
              deviceName: parts[1],
              serviceUuid: parts[2],
              configCharacteristicUuid: parts[3],
              versionCharacteristicUuid: parts[4],
              checkWiFiCredentialsCharacteristicUuid: parts[5],
            ),
          );
        }
        break;
      case 'TV-PAIR':
        if (parts.length == 3) {
          return ParseQrDataModel(
            type: QrCodeType.tvPairing,
            payload: TvQrModel(
              tvId: parts[1],
              pairingCode: parts[2],
            ),
          );
        }
        break;
    }

    return ParseQrDataModel(type: QrCodeType.unknown);
  }
}
