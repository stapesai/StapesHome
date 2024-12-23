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
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/widgets/enter_wifi_cred.dart';
import 'package:stapes_home/features/nodes/domain/usecases/pair_node_usecase.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';
import 'package:stapes_home/service_locator.dart';


 enum StepStatus {
    pending,
    current,
    completed,
  }

  class ProvisioningStep {
    final String title;

    final StepStatus status;

    ProvisioningStep({
      required this.title,
      required this.status,
  
    });
  }
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
      )..add(PairBleDeviceEvent(qrData)),
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
    List<ProvisioningStep> getSteps(IotProvisioningState state) {
      return [
        ProvisioningStep(
          title: 'Pairing Bluetooth',
          status: state is BlePairingInProgress 
              ? StepStatus.current
              : state is BlePairingSuccess || state is LoadingWifiNetworks || 
                state is WifiNetworksLoaded || state is CheckingWifiCredentials || 
                state is WifiCredentialsValid
                  ? StepStatus.completed 
                  : StepStatus.pending,
        
        ),
       

        ProvisioningStep(
          title: 'Checking Wi-Fi credentials',
          status: state is CheckingWifiCredentials
              ? StepStatus.current
              : state is WifiCredentialsValid
                  ? StepStatus.completed
                  : StepStatus.pending,
        ),
        ProvisioningStep(
          title: 'Enter Node Name',
          status: state is CheckingWifiCredentials
              ? StepStatus.current
              : state is WifiCredentialsValid
                  ? StepStatus.completed
                  : StepStatus.pending,
        ),
        ProvisioningStep(
          title: 'Checking provisioning status',
          status: state is RequestingNodePairing || 
                 state is UploadConfigToNode || 
                 state is CompletingNodePairing
              ? StepStatus.current
              : state is NodeProvisioned
                  ? StepStatus.completed
                  : StepStatus.pending,
        ),
      ];
    }

    if (state is BlePairingFailure) {
      return _buildErrorState(state.error);
    } 
    
     if (state is BlePairingSuccess || 
              state is LoadingWifiNetworks || 
              state is WifiNetworksLoaded) {
      return Column(
        children: [
          _buildStepIndicator(getSteps(state)),
          EnterWifiCredWidget(),
          const SizedBox(height: 24),
        ],
      );
    }  
    
    if (state is CheckingWifiCredentials) {
      return Column(
        children: [
          _buildStepIndicator(getSteps(state)),
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      );
      
    }
    if (state is NodeProvisioned) {
      return Column(
        children: [
          _buildStepIndicator([
            ProvisioningStep(
              title: 'Pairing Bluetooth',
              status: StepStatus.completed,
            ),
            ProvisioningStep(
              title: 'Checking Wi-Fi credentials',
              status: StepStatus.completed,
            ),
            ProvisioningStep(
              title: 'Checking provisioning status',
              status: StepStatus.completed,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSuccessState(),
        ],
      );
    } else {
      return _buildStepIndicator(getSteps(state));
    }
  }

 Widget _buildStepIndicator(List<ProvisioningStep> steps) {
    return Column(
      children: steps.map((step) => _buildStep(step)).toList(),
    );
  }

  Widget _buildStep(ProvisioningStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStepColor(step.status),
            ),
            child: _getStepIndicator(step.status),
          ),
          const SizedBox(width: 12),
          Text(
            step.title,
            style: TextStyle(
              color: _getTextColor(step.status),
              fontSize: 18,
              fontFamily: 'Ubuntu',
            ),
          ),
          
        ],
      ),
    );
  }

 

  Color _getStepColor(StepStatus status) {
    switch (status) {
      case StepStatus.current:
        return const Color(0xFFFF9F1C);
      case StepStatus.completed:
        return Colors.green;
      case StepStatus.pending:
        return const Color(0x7FFF9F1C);
    }
  }

  Color _getTextColor(StepStatus status) {
    switch (status) {
      case StepStatus.pending:
        return Colors.white.withOpacity(0.5);
      case StepStatus.current:
      case StepStatus.completed:
        return Colors.white;
    }
  }

  Widget _getStepIndicator(StepStatus status) {
    switch (status) {
      case StepStatus.current:
        return const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        );
      case StepStatus.completed:
        return const Icon(
          Icons.check,
          color: Colors.white,
        );
      case StepStatus.pending:
        return const SizedBox();
    }
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