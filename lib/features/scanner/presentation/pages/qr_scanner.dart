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
  late MobileScannerController _controller;
  bool _torchOn = false;
  bool _hasTorch = true; // Assume torch is available until proven otherwise

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrScannerBloc(),
      child: BlocListener<QrScannerBloc, QrScannerState>(
        listener: (context, state) {
          if (state is QrScannerSuccess) {
            switch (state.data.type) {
              case QrCodeType.iotNode:
                GoRouter.of(context).push(
                  AppRouteConstants.iotProvisioning.routeName,
                  extra: state.data.payload,
                );
                break;
              case QrCodeType.tvPairing:
                GoRouter.of(context).push(AppRouteConstants.tvProvisioning.routeName);
                break;
              case QrCodeType.unknown:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid QR code')),
                );
                break;
            }
          } else if (state is QrScannerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          // TODO: add loading overlay for QrScannerProcessing state
        },
        child: Scaffold(
          body: Stack(
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
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
                    onPressed: _toggleTorch,
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
            ],
          ),
        ),
      ),
    );
  }
}
