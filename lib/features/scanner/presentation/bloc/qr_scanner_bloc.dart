// lib/features/scanner/presentation/bloc/qr_scanner_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/scanner/data/models/parse_qr_data_model.dart';
import 'package:stapes_home/features/scanner/presentation/bloc/qr_scanner_event.dart';
import 'package:stapes_home/features/scanner/presentation/bloc/qr_scanner_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  QrScannerBloc() : super(QrScannerInitial()) {
    on<ProcessQrCode>((event, emit) async {
      emit(QrScannerProcessing());

      try {
        final parsedData = ParseQrDataModel.fromQrString(event.qrData);
        emit(QrScannerSuccess(parsedData));
      } catch (e) {
        emit(QrScannerError('Failed to process QR code: ${e.toString()}'));
      }
    });
  }
}
