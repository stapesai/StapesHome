// qr_scanner.dart

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
  bool _hasTorch = true;
  late QrScannerBloc _qrScannerBloc;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _qrScannerBloc = QrScannerBloc();

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _controller.start();
    } catch (e) {
      print('Failed to initialize camera: $e');
      if (mounted) {
        CustomSnackbar(context, 'Failed to initialize camera', type: SnackbarType.error);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _qrScannerBloc.close();
    super.dispose();
  }

  void _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      setState(() {
        _torchOn = !_torchOn;
      });
    } catch (e) {
      print('Torch is not available: $e');
      setState(() {
        _hasTorch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _qrScannerBloc),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<QrScannerBloc, QrScannerState>(
            listener: (context, state) {
              print('BlocListener received state: $state');
              if (state is QrScannerSuccess) {
                try {
                  switch (state.data.type) {
                    case QrCodeType.iotNode:
                      print('Navigating to IoT Provisioning');
                      GoRouter.of(context).push(
                        AppRouteConstants.iotProvisioning.routeName,
                        extra: state.data.payload,
                      );
                      break;
                    case QrCodeType.tvPairing:
                      print('Navigating to TV Provisioning');
                      GoRouter.of(context).push(AppRouteConstants.tvProvisioning.routeName);
                      break;
                    case QrCodeType.unknown:
                      CustomSnackbar(context, 'Unknown QR code type', type: SnackbarType.error);
                      break;
                  }
                } catch (e, stackTrace) {
                  print('Navigation error: $e');
                  print('Stack trace: $stackTrace');
                  CustomSnackbar(
                    context,
                    'Failed to navigate: ${e.toString()}',
                    type: SnackbarType.error,
                  );
                }
              } else if (state is QrScannerError) {
                CustomSnackbar(context, state.message, type: SnackbarType.error);
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  MobileScanner(
                    controller: _controller,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      print('onDetect called with barcodes: $barcodes');
                      if (barcodes.isNotEmpty) {
                        final rawValue = barcodes.first.rawValue;
                        print('Scanned QR code raw value: $rawValue');
                        if (rawValue != null) {
                          _qrScannerBloc.add(
                            ProcessQrCode(rawValue),
                          );
                        } else {
                          print('Raw value is null');
                        }
                      } else {
                        print('No barcodes detected');
                      }
                    },
                  ),
                  const QRScannerOverlay(),
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
                  // Temporary button to test navigation
                  // Remove this after testing
                  Positioned(
                    bottom: 100,
                    left: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push(AppRouteConstants.iotProvisioning.routeName);
                      },
                      child: const Text('Test Navigation'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}