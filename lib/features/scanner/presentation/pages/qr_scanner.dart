// lib/features/provisioning/presentation/pages/scanner/qr_scanner.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/features/scanner/data/models/parse_qr_data_model.dart';
import 'package:stapes_home/features/scanner/presentation/bloc/qr_scanner_bloc.dart';
import 'package:stapes_home/features/scanner/presentation/bloc/qr_scanner_event.dart';
import 'package:stapes_home/features/scanner/presentation/bloc/qr_scanner_state.dart';
import 'package:stapes_home/features/scanner/presentation/widgets/scan_instructions.dart';
import 'package:stapes_home/features/scanner/presentation/widgets/scanner_overlay.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with WidgetsBindingObserver {
  late final QrScannerBloc _qrScannerBloc;
  late MobileScannerController _controller;
  bool _torchOn = false;
  bool _hasTorch = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _qrScannerBloc = QrScannerBloc();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    // Initialize camera
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _controller.start();
    } catch (e) {
      print('Failed to initialize camera: $e');
      if (mounted) {
        CustomSnackbar(context, 'Failed to initialize camera');
      }
    }
  }

  void _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      setState(() {
        _torchOn = !_torchOn;
      });

      // TODO: Check if torch is toggled successfully
    } catch (e) {
      // If an error occurs (torch not available), we can assume there's no torch
      print('Torch is not available: $e');
      setState(() {
        _hasTorch = false; // Hide the torch toggle button if not available
      });
    }
  }

  Future<void> _handleQrDetection(BarcodeCapture capture) async {
    if (_isProcessing) return; // Prevent multiple simultaneous processing

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    try {
      setState(() => _isProcessing = true);
      await _controller.stop(); // Stop scanning while processing

      final String? qrData = barcodes.first.rawValue;
      if (qrData == null) {
        throw Exception('Invalid QR code data');
      }

      if (mounted) {
        context.read<QrScannerBloc>().add(ProcessQrCode(qrData));
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar(context, 'Error processing QR code: ${e.toString()}');
        await _controller.start(); // Restart scanning on error
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _qrScannerBloc,
    child: Builder(builder: (context) {
        return BlocListener<QrScannerBloc, QrScannerState>(
          listener: (context, state) async {
            if (state is QrScannerSuccess) {
              try {
                switch (state.data.type) {
                  case QrCodeType.iotNode:
                    print('IoT Node QR code detected');
                    if (mounted) {
                      await context.push(AppRouteConstants.iotProvisioning.routeName, extra: state.data.payload);
                    }
                    break;
                  case QrCodeType.tvPairing:
                    if (mounted) {
                      await context.push(
                        AppRouteConstants.tvProvisioning.routeName,
                      );
                    }
                    break;
                  case QrCodeType.unknown:
                    CustomSnackbar(context, 'Unknown QR code type', type: SnackbarType.error);
                    break;
                }
              } finally {
                if (mounted) {
                  await _controller.start();
                  setState(() => _isProcessing = false);
                }
              }
            } else if (state is QrScannerError) {
              CustomSnackbar(context, state.message, type: SnackbarType.error);
              if (mounted) {
                await _controller.start();
                setState(() => _isProcessing = false);
              }
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      print('Barcode detected: ${barcodes.first.rawValue}');
                      context.read<QrScannerBloc>().add(
                            ProcessQrCode(barcodes.first.rawValue ?? ''),
                          );
                    }
                  },
                ),
                QRScannerOverlay(),
                if (_hasTorch)
                  Positioned(
                    top: 45,
                    right: 20,
                    child: IconButton(
                      onPressed: _isProcessing ? null : _toggleTorch,
                      icon: Icon(
                        _torchOn ? Icons.flashlight_on : Icons.flashlight_off,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: QrScanInstructionPanel(),
                ),
                if (_isProcessing)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
