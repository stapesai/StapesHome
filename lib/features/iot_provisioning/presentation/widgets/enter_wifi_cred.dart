// lib/features/iot_provisioning/presentation/widgets/enter_wifi_cred.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/common/widgets/input/dropdown.dart';
import 'package:stapes_home/core/common/widgets/input/password.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';

class EnterWifiCredWidget extends StatefulWidget {
  const EnterWifiCredWidget({super.key});

  @override
  State<EnterWifiCredWidget> createState() => _EnterWifiCredWidgetState();
}

class _EnterWifiCredWidgetState extends State<EnterWifiCredWidget> {
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedNetwork;

  @override
  void initState() {
    super.initState();
    context.read<IotProvisioningBloc>().add(GetAvailableWifiNetworksEvent());
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IotProvisioningBloc, IotProvisioningState>(
      builder: (context, state) {
        if (state is LoadingWifiNetworks) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is WifiNetworksLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomDropdown<String>(
                hintText: 'Select WiFi Network',
                value: _selectedNetwork,
                items: state.networks
                    .map((network) => DropdownMenuItem(
                          value: network.ssid,
                          child: Text(network.ssid),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedNetwork = value),
              ),
              const SizedBox(height: 16),
              CustomPasswordTextField(
                controller: _passwordController,
                hintText: 'WiFi Password',
              ),
              const Spacer(),
              CustomButton(
                  text: 'Connect',
                  onPressed: () {
                    if (_selectedNetwork == null || _passwordController.text.isEmpty) {
                      return;
                    }
                    context.read<IotProvisioningBloc>().add(
                          CheckWifiCredentialsEvent(
                            ssid: _selectedNetwork!,
                            password: _passwordController.text,
                          ),
                        );
                  }),
            ],
          );
        }

        return const Center(child: Text('Failed to load WiFi networks'));
      },
    );
  }
}
