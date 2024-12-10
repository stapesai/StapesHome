// // lib/features/iot_provisioning/presentation/pages/enter_wifi_credentials.dart

//! DELETE THIS FILE

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:go_router/go_router.dart';
// import 'package:stapes_home/core/common/widgets/button.dart';
// import 'package:stapes_home/core/common/widgets/input/dropdown.dart';
// import 'package:stapes_home/core/common/widgets/input/password.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/core/theme/app_padding.dart';
// import 'package:stapes_home/core/constants/app_route_constants.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';

// class WifiCredentialsScreen extends StatefulWidget {
//   final BluetoothDevice bleDevice;

//   const WifiCredentialsScreen({
//     super.key,
//     required this.bleDevice,
//   });

//   @override
//   State<WifiCredentialsScreen> createState() => _WifiCredentialsScreenState();
// }

// class _WifiCredentialsScreenState extends State<WifiCredentialsScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   String? _selectedNetwork;
//   BluetoothCharacteristic? _wifiChar;

//   @override
//   void initState() {
//     super.initState();
//     _setupBleCharacteristic();
//     _loadWifiNetworks();
//   }

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _setupBleCharacteristic() async {
//     final services = await widget.bleDevice.discoverServices();
//     for (var service in services) {
//       for (var char in service.characteristics) {
//         if (char.uuid.toString() == 'wifi-check-uuid') {
//           // Get from QR
//           _wifiChar = char;
//           break;
//         }
//       }
//     }
//   }

//   void _loadWifiNetworks() {
//     context.read<IotProvisioningBloc>().add(GetAvailableWifiNetworksEvent());
//   }

//   void _validateCredentials() {
//     if (_selectedNetwork != null && _passwordController.text.isNotEmpty && _wifiChar != null) {
//       context.read<IotProvisioningBloc>().add(CheckWifiCredentialsEvent(
//             ssid: _selectedNetwork!,
//             password: _passwordController.text,
//             characteristic: _wifiChar!,
//           ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<IotProvisioningBloc, IotProvisioningState>(
//         listener: (context, state) {
//           if (state is WifiCredentialsValid) {
//             context.pushNamed(
//               AppRouteConstants.selectNodeOptions,
//               extra: {
//                 'device': widget.bleDevice,
//                 'ssid': _selectedNetwork,
//                 'password': _passwordController.text,
//               },
//             );
//           }
//         },
//         builder: (context, state) {
//           return Container(
//             decoration: const BoxDecoration(
//               gradient: AppColor.backgroundColorgradient,
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: AppPadding.pagePadding(context),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'WiFi Setup',
//                       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                             color: Colors.white,
//                           ),
//                     ),
//                     const SizedBox(height: 20),
//                     if (state is LoadingWifiNetworks)
//                       const Center(child: CircularProgressIndicator())
//                     else if (state is WifiNetworksLoaded)
//                       CustomDropdown<String>(
//                         value: _selectedNetwork,
//                         items: state.networks
//                             .map((network) => DropdownMenuItem(
//                                   value: network.ssid,
//                                   child: Text(network.ssid),
//                                 ))
//                             .toList(),
//                         onChanged: (value) => setState(() => _selectedNetwork = value),
//                         hint: 'Select WiFi Network',
//                       ),
//                     const SizedBox(height: 20),
//                     CustomPasswordTextField(
//                       controller: _passwordController,
//                       hintText: 'WiFi Password',
//                     ),
//                     const Spacer(),
//                     if (state is CheckingWifiCredentials)
//                       const Center(child: CircularProgressIndicator())
//                     else if (state is WifiCredentialsInvalid)
//                       Text(
//                         state.error,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     CustomButton(
//                       text: 'Connect',
//                       onPressed: _validateCredentials,
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
