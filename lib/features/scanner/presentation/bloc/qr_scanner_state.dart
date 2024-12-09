// lib/features/scanner/presentation/bloc/qr_scanner_state.dart

import 'package:stapes_home/features/scanner/data/models/parse_qr_data_model.dart';

import 'package:equatable/equatable.dart';

abstract class QrScannerState extends Equatable {
  const QrScannerState();

  @override
  List<Object?> get props => [];
}

class QrScannerInitial extends QrScannerState {}

class QrScannerProcessing extends QrScannerState {}

class QrScannerSuccess extends QrScannerState {
  final ParseQrDataModel data;

  const QrScannerSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class QrScannerError extends QrScannerState {
  final String message;

  const QrScannerError(this.message);

  @override
  List<Object> get props => [message];
}
