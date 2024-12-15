// lib/features/scanner/presentation/bloc/qr_scanner_event.dart

import 'package:equatable/equatable.dart';

abstract class QrScannerEvent extends Equatable {
  const QrScannerEvent();

  @override
  List<Object> get props => [];
}

class ProcessQrCode extends QrScannerEvent {
  final String qrData;

  const ProcessQrCode(this.qrData);

  @override
  List<Object> get props => [qrData];
}
