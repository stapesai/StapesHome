// lib/features/provisioning/presentation/pages/scanner/qr_scanner.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';
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
  // late MobileScannerController controller;
  final controller = MobileScannerController(
    autoStart: false,
    torchEnabled: false,
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  StreamSubscription<Object?>? _subscription;
  late QrScannerBloc _qrScannerBloc;
  late TorchState torchState;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _qrScannerBloc = QrScannerBloc();

    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  void _toggleTorch() async {
    try {
      await controller.toggleTorch();
      setState(() {
        _torchOn = !_torchOn;
      });
    } catch (e) {
      if (mounted) {
        switch (torchState) {
          case TorchState.unavailable:
            CustomSnackbar(context, "Flashlight is not availabel", type: SnackbarType.info);
            break;
          default:
            break;
        }
      }
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    Barcode? barcode = barcodes.barcodes.firstOrNull;
    if (barcode != null) {
      unawaited(controller.stop());
      _qrScannerBloc.add(
        ProcessQrCode(barcode.rawValue.toString()),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        return;
      case AppLifecycleState.hidden:
        return;
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _qrScannerBloc,
      child: BlocListener<QrScannerBloc, QrScannerState>(
        listener: (context, state) {
          debugPrint('BlocListener received state: $state');
          if (state is QrScannerSuccess) {
            debugPrint('Navigating with parsed data: ${state.data}');
            switch (state.data.type) {
              case QrCodeType.iotNode:
                debugPrint('Navigating to IoT Provisioning');
                GoRouter.of(context).push(
                  AppRouteConstants.iotProvisioning.routePath,
                  extra: state.data.payload,
                ).then((_) {
                  if (mounted) unawaited(controller.start());
                });
                break;
              case QrCodeType.tvPairing:
                debugPrint('Navigating to TV Provisioning');
                GoRouter.of(context).push(AppRouteConstants.tvProvisioning.routeName);
                break;
              case QrCodeType.unknown:
                CustomSnackbar(context, 'Unknown QR code type', type: SnackbarType.error);
                break;
            }
          } else if (state is QrScannerError) {
            debugPrint('Error: ${state.message}');
            CustomSnackbar(context, state.message, type: SnackbarType.error);
          } else if (state is QrScannerProcessing) {
            debugPrint('Processing QR code...');
            CustomSnackbar(context, 'Initialising pairing process', type: SnackbarType.info);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              MobileScanner(
                controller: controller,
              ),
              QRScannerOverlay(),
              const Align(
                alignment: Alignment.bottomCenter,
                child: QrScanInstructionPanel(),
              ),
              // back button
              Positioned(
                top: 45,
                left: 20,
                child: IconButton(
                  onPressed: () {
                    final navigationBloc = context.read<NavigationBloc>();
                    // Navigate back to the first tab (or whichever tab you want to return to)
                    navigationBloc.add(NavigationItemSelected(NavigationTab.values[0]));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),

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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    // unawaited(_subscription?.cancel());
    _subscription?.cancel();
    _subscription = null;
    _qrScannerBloc.close();
    //*: god knows if i don't await this, why does it work?
    controller.dispose();
    // await controller.dispose();
    super.dispose();
  }
}
