// lib/features/iot_provisioning/presentation/pages/iot_provisioning.dart

import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/features/nodes/domain/usecases/pair_node_usecase.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/widgets/enter_wifi_cred.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_pair_node.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_get_hw_info.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_upload_config.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_check_wifi_credentials.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_wifi_get_available_nwtworks.dart';

enum StepStatus {
  pending,
  current,
  completed,
  error,
}

class ProvisioningStep {
  final String title;
  final StepStatus status;
  final String? error;

  ProvisioningStep({
    required this.title,
    required this.status,
    this.error,
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
                        'Provisioning',
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Node',
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
          status: state is BlePairingFailure
              ? StepStatus.error
              : state is BlePairingInProgress
                  ? StepStatus.current
                  : state is BlePairingSuccess ||
                          state is LoadingWifiNetworks ||
                          state is WifiNetworksLoaded ||
                          state is WifiNetworksError ||
                          state is CheckingWifiCredentials ||
                          state is WifiCredentialsValid
                      ? StepStatus.completed
                      : StepStatus.pending,
          error: state is BlePairingFailure ? state.error : null,
        ),
        ProvisioningStep(
          title: _getWifiStepTitle(state),
          status: state is WifiNetworksError
              ? StepStatus.error
              : state is WifiNetworksLoaded
                  ? StepStatus.current
                  : state is CheckingWifiCredentials
                      ? StepStatus.current
                      : state is WifiCredentialsValid
                          ? StepStatus.completed
                          : StepStatus.pending,
          error: state is WifiNetworksError ? state.error : null,
        ),
        ProvisioningStep(
          title: 'Validating Node Credentials',
          status: state is WifiCredentialsInvalid
              ? StepStatus.error
              : state is WifiCredentialsValid
                  ? StepStatus.completed
                  : StepStatus.pending,
          error: state is WifiCredentialsInvalid ? state.error : null,
        ),
        ProvisioningStep(
          title: 'Requesting Server to Pair Node',
          status: state is NodePairingRequestFailure
              ? StepStatus.error
              : state is RequestingNodePairing
                  ? StepStatus.current
                  : state is NodePairingRequestSuccess ||
                          // if node pairing request is done, subsequent steps might have started
                          state is UploadConfigToNode ||
                          state is UploadConfigToNodeSuccess ||
                          state is UploadConfigToNodeFailure ||
                          state is CompletingNodePairing ||
                          state is CompleteNodePairingSuccess ||
                          state is CompleteNodePairingFailure ||
                          state is NodeProvisioned
                      ? StepStatus.completed
                      : StepStatus.pending,
          error: state is NodePairingRequestFailure ? state.error : null,
        ),
        ProvisioningStep(
          title: 'Uploading Config to Node',
          status: state is UploadConfigToNodeFailure
              ? StepStatus.error
              : state is UploadConfigToNode
                  ? StepStatus.current
                  : state is UploadConfigToNodeSuccess ||
                          // if config is uploaded, provisioning might be completing
                          state is CompletingNodePairing ||
                          state is CompleteNodePairingSuccess ||
                          state is CompleteNodePairingFailure ||
                          state is NodeProvisioned
                      ? StepStatus.completed
                      : StepStatus.pending,
          error: state is UploadConfigToNodeFailure ? state.error : null,
        ),
        ProvisioningStep(
          title: 'Completing Node Pairing',
          status: state is CompleteNodePairingFailure || state is NodeProvisioningError
              ? StepStatus.error
              : state is CompletingNodePairing
                  ? StepStatus.current
                  : state is CompleteNodePairingSuccess || state is NodeProvisioned
                      ? StepStatus.completed
                      : StepStatus.pending,
          error:
              state is CompleteNodePairingFailure ? state.error : (state is NodeProvisioningError ? state.error : null),
        ),
      ];
    }

    if (state is BlePairingSuccess || state is LoadingWifiNetworks || state is WifiNetworksLoaded) {
      return Column(
        children: [
          _buildStepIndicator(getSteps(state)),
          EnterWifiCredWidget(),
          const SizedBox(height: 24),
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
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return _buildStep(step, index, steps);
      }).toList(),
    );
  }

  Widget _buildStep(ProvisioningStep step, int index, List<ProvisioningStep> steps) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getStepColor(step.status),
                ),
                child: step.status == StepStatus.error // Add error status handling
                    ? _getStepIndicator(StepStatus.error)
                    : _getStepIndicator(step.status),
              ),
              const SizedBox(width: 12),
              Text(
                step.title,
                style: TextStyle(
                  color: _getStepTextColor(step.status, index, steps),
                  fontSize: 18,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ],
          ),
          if (step.error != null) // Show error message if present
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 4),
              child: Text(
                step.error!,
                style: TextStyle(
                  color: _getTextColor(step.status),
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStepTextColor(StepStatus status, int index, List<ProvisioningStep> steps) {
    // Make only the current or next step fully white, others have 50% opacity
    if (status == StepStatus.error) {
      return Colors.red;
    } else if (status == StepStatus.current) {
      return Colors.white;
    } else if (status == StepStatus.completed) {
      return Colors.white.withOpacity(0.7);
    } else {
      // For pending steps, if the previous step is completed, make text white,
      // else use white with 50% opacity
      if (index > 0 && steps[index - 1].status == StepStatus.completed) {
        return Colors.white;
      } else {
        return Colors.white.withOpacity(0.7);
      }
    }
  }

  String _getWifiStepTitle(IotProvisioningState state) {
    if (state is CheckingWifiCredentials) {
      return 'Checking Wi-Fi credentials';
    } else if (state is WifiCredentialsValid) {
      return 'Wi-Fi credentials verified';
    } else if (state is WifiCredentialsInvalid) {
      return 'Enter Wi-Fi credentials';
    } else if (state is WifiNetworksLoaded) {
      return 'Enter Wi-Fi credentials';
    } else {
      return 'Wi-Fi setup';
    }
  }

  Color _getStepColor(StepStatus status) {
    switch (status) {
      case StepStatus.current:
        return const Color(0xFFFF9F1C);
      case StepStatus.completed:
        return const Color.fromARGB(255, 73, 255, 79);
      case StepStatus.pending:
        return const Color(0x7FFF9F1C);
      case StepStatus.error:
        return const Color.fromARGB(255, 255, 17, 0);
    }
  }

  Color _getTextColor(StepStatus status) {
    switch (status) {
      case StepStatus.pending:
        return Colors.white.withOpacity(0.5);
      case StepStatus.current:
      case StepStatus.completed:
        return Colors.white;
      case StepStatus.error:
        return Colors.red;
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
      case StepStatus.error:
        return const Icon(
          Icons.close,
          color: Colors.white,
        );
    }
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
