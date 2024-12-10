// // lib/features/iot_provisioning/presentation/pages/select_node_options.dart

//! DELETE THIS FILE

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:stapes_home/core/common/widgets/button.dart';
// import 'package:stapes_home/core/common/widgets/input/textfield.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/core/theme/app_padding.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';

// class NodeOptionsScreen extends StatefulWidget {
//   final Map<String, dynamic> provisioningData;

//   const NodeOptionsScreen({
//     super.key,
//     required this.provisioningData,
//   });

//   @override
//   State<NodeOptionsScreen> createState() => _NodeOptionsScreenState();
// }

// class _NodeOptionsScreenState extends State<NodeOptionsScreen> {
//   final TextEditingController _nodeNameController = TextEditingController();
//   String? _selectedRoomId;
//   BluetoothCharacteristic? _hwInfoChar;
//   BluetoothCharacteristic? _configChar;

//   @override
//   void initState() {
//     super.initState();
//     _setupBleCharacteristics();
//     _getNodeHwInfo();
//   }

//   @override
//   void dispose() {
//     _nodeNameController.dispose();
//     super.dispose();
//   }

//   Future<void> _setupBleCharacteristics() async {
//     final device = widget.provisioningData['device'] as BluetoothDevice;
//     final services = await device.discoverServices();
//     for (var service in services) {
//       for (var char in service.characteristics) {
//         if (char.uuid.toString() == 'hw-info-uuid') {
//           _hwInfoChar = char;
//         }
//         if (char.uuid.toString() == 'config-uuid') {
//           _configChar = char;
//         }
//       }
//     }
//   }

//   void _getNodeHwInfo() {
//     if (_hwInfoChar != null) {
//       context.read<IotProvisioningBloc>().add(GetNodeHwInfoEvent(_hwInfoChar!));
//     }
//   }

//   void _completeSetup() {
//     if (_selectedRoomId != null && _nodeNameController.text.isNotEmpty && _configChar != null) {
//       // First request node pairing
//       context.read<IotProvisioningBloc>().add(RequestNodePairingEvent(
//             roomId: _selectedRoomId!,
//             nodeName: _nodeNameController.text,
//             hwInfo: (context.read<IotProvisioningBloc>().state as NodeHwInfoLoaded).hwInfo,
//           ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<IotProvisioningBloc, IotProvisioningState>(
//         listener: (context, state) {
//           if (state is NodePairingRequestSuccess) {
//             // Send config to node
//             context.read<IotProvisioningBloc>().add(SendNodeConfigEvent(
//                   configChar: _configChar!,
//                   ssid: widget.provisioningData['ssid'],
//                   password: widget.provisioningData['password'],
//                   userId: 'user-id', // Get from auth service
//                   mqttDetails: {
//                     'host': 'mqtt-host',
//                     'port': 'mqtt-port',
//                     'username': 'mqtt-username',
//                     'password': 'mqtt-password',
//                   },
//                 ));
//           } else if (state is NodeConfigSent) {
//             // Complete pairing in backend
//             context.read<IotProvisioningBloc>().add(CompleteNodePairingEvent(
//                   (context.read<IotProvisioningBloc>().state as NodePairingRequestSuccess).transactionId,
//                 ));
//           } else if (state is NodePairingComplete) {
//             context.pop(); // Return to previous screen
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
//                       'Node Setup',
//                       style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                             color: Colors.white,
//                           ),
//                     ),
//                     const SizedBox(height: 20),
//                     CustomTextField(
//                       controller: _nodeNameController,
//                       hintText: 'Node Name',
//                       icon: Icons.device_hub,
//                     ),
//                     const SizedBox(height: 20),
//                     FloorRoomSelWidget(
//                       onRoomSelected: (roomId) => _selectedRoomId = roomId,
//                     ),
//                     const Spacer(),
//                     if (state is RequestingNodePairing || state is SendingNodeConfig || state is CompletingNodePairing)
//                       const Center(child: CircularProgressIndicator())
//                     else if (state is NodePairingRequestFailure ||
//                         state is NodeConfigError ||
//                         state is NodePairingError)
//                       Text(
//                         'Error: ${state.toString()}',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     CustomButton(
//                       text: 'Complete Setup',
//                       onPressed: _completeSetup,
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
