// lib/features/iot_provisioning/presentation/pages/iot_provisioning.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_check_wifi_credentials.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_get_hw_info.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_pair_node.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_upload_config.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_wifi_get_available_nwtworks.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/widgets/enter_wifi_cred.dart';
import 'package:stapes_home/features/nodes/domain/usecases/pair_node_usecase.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';
import 'package:stapes_home/service_locator.dart';

class IoTProvisioningScreen extends StatelessWidget {
  final IotQrModel qrData;

  const IoTProvisioningScreen({
    super.key,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => IotProvisioningBloc(
        pairBleNodeUseCase: serviceLocator<PairBleNodeUseCase>(),
        getAvailableWifiNetworksUseCase: serviceLocator<GetAvailableWifiNetworksUseCase>(),
        checkWifiCredentialsUseCase: serviceLocator<CheckWifiCredentialsUseCase>(),
        getHwInfoUseCase: serviceLocator<GetHwInfoUseCase>(),
        sendConfigToNodeUseCase: serviceLocator<SendConfigToNodeUseCase>(),
        requestNodePairingUseCase: serviceLocator<RequestNodePairingUseCase>(),
        completeNodePairingUseCase: serviceLocator<CompleteNodePairingUseCase>(),
        authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColor.backgroundColorgradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: AppPadding.pagePadding(context),
              child: BlocBuilder<IotProvisioningBloc, IotProvisioningState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),
                      Text(
                        'Provisioning Node',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Text(
                        'Setting up your device...',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageSubHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.04),
                      Center(
                        child: SizedBox(
                          width: 122.69,
                          height: 132.19,
                          child: Lottie.asset(
                            'assets/loties/cube.json',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.04),
                      Expanded(
                        child: _buildCurrentStep(context, state),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, IotProvisioningState state) {
    if (state is BlePairingInProgress) {
      return _buildStepIndicator('Pairing Bluetooth', true);
    } else if (state is BlePairingFailure) {
      return _buildErrorState(state.error);
    } else if (state is BlePairingSuccess || state is LoadingWifiNetworks || state is WifiNetworksLoaded) {
      return EnterWifiCredWidget();
    } else if (state is CheckingWifiCredentials) {
      return _buildStepIndicator('Checking WiFi Credentials', true);
    } else if (state is WifiCredentialsInvalid) {
      return _buildErrorState(state.error);
    } else if (state is WifiCredentialsValid) {
      return Text('Wifi Credentials Valid');
      // return NameYourNodeWidget();
    } else if (state is NodePairingRequestSuccess) {
      return Text('Node Pairing Request Success');
      // return SelectNodeLocationWidget();
    } else if (state is RequestingNodePairing) {
      return _buildStepIndicator('Requesting Server', true);
    } else if (state is UploadConfigToNode) {
      return _buildStepIndicator('Uploading Configuration', true);
    } else if (state is CompletingNodePairing) {
      return _buildStepIndicator('Completing Setup', true);
    } else if (state is NodeProvisioned) {
      return _buildSuccessState();
    } else {
      return _buildStepIndicator('Initializing...', true);
    }
  }

Widget _buildStepIndicator(String title, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLoading ? Color(0xFFFF9F1C) : Color(0x7FFF9F1C),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: isLoading ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 18,
              fontFamily: 'Ubuntu',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
          SizedBox(height: 16),
          Text(
            'Device Successfully Provisioned!',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}