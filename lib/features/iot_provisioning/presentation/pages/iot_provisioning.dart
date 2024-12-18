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

class ProvisioningStep {
  final String title;
  bool isCompleted;
  bool isCurrent;

  ProvisioningStep({
    required this.title,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class IoTProvisioningScreen extends StatelessWidget {
  final IotQrModel qrData;

  IoTProvisioningScreen({
    super.key,
    required this.qrData,
  });
  // Stream<int> _widgetSequence() async* {
  //   for (int i = 0; i < 4; i++) {
  //     await Future.delayed(const Duration(seconds: 2));
  //     yield i;
  //   }
  // }
  List<ProvisioningStep> steps = [
    ProvisioningStep(title: 'Pairing Bluetooth', isCurrent: true),
    ProvisioningStep(title: 'Enter Wi-Fi Credentials'),
    ProvisioningStep(title: 'Name your node'),
    ProvisioningStep(title: 'Sending Wi-Fi credentials'),
  ];

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
                      ...steps.map((step) => _buildStepIndicator(step)),
                      Spacer(),

                      // child: StreamBuilder<int>(
                      //   stream: _widgetSequence(),
                      //   initialData: 0,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       return Center(child: _buildCurrentStep(snapshot.data!));
                      //     } else {
                      //       return Center(child: _buildStepIndicator());
                      //     }
                      //   },
                      // ),
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

  // Widget _buildCurrentStep(BuildContext context, IotProvisioningState state) {
  //   if (state is BlePairingInProgress) {
  //     return _buildStepIndicator('Pairing Bluetooth', true);
  //   } else if (state is BlePairingFailure) {
  //     return _buildErrorState(state.error);
  //   } else if (state is BlePairingSuccess || state is LoadingWifiNetworks || state is WifiNetworksLoaded) {
  //     return EnterWifiCredWidget();
  //   } else if (state is CheckingWifiCredentials) {
  //     return _buildStepIndicator('Checking WiFi Credentials', true);
  //   } else if (state is WifiCredentialsInvalid) {
  //     return _buildErrorState(state.error);
  //   } else if (state is WifiCredentialsValid) {
  //     return Text('Wifi Credentials Valid');
  //     // return NameYourNodeWidget();
  //   } else if (state is NodePairingRequestSuccess) {
  //     return Text('Node Pairing Request Success');
  //     // return SelectNodeLocationWidget();
  //   } else if (state is RequestingNodePairing) {
  //     return _buildStepIndicator('Requesting Server', true);
  //   } else if (state is UploadConfigToNode) {
  //     return _buildStepIndicator('Uploading Configuration', true);
  //   } else if (state is CompletingNodePairing) {
  //     return _buildStepIndicator('Completing Setup', true);
  //   } else if (state is NodeProvisioned) {
  //     return _buildSuccessState();
  //   } else {
  //     return _buildStepIndicator('Initializing...', true);
  //   }
  // }


  Widget _buildStepIndicator(ProvisioningStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step.isCompleted
                  ? Color(0xFFFF9F1C)
                  : step.isCurrent
                      ? Color(0xFFFF9F1C)
                      : Color(0x7FFF9F1C),
            ),
            child: step.isCompleted
                ? Icon(Icons.check_circle, color: Colors.greenAccent[400])
                : step.isCurrent
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        strokeWidth: 2,
                      )
                    : null,
          ),
          SizedBox(width: 10),
          Text(
            step.title,
            style: TextStyle(
              color: step.isCompleted || step.isCurrent ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 20,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}


