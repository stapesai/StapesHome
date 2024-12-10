// // lib/features/iot_provisioning/presentation/pages/iot_provisioning.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/core/theme/app_padding.dart';
// import 'package:stapes_home/core/constants/app_route_constants.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
// import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';
// import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';

// class IotProvisioningScreen extends StatefulWidget {
//   final IotQrModel qrData;

//   const IotProvisioningScreen({
//     super.key,
//     required this.qrData,
//   });

//   @override
//   State<IotProvisioningScreen> createState() => _ProvisioningScreenState();
// }

// class _ProvisioningScreenState extends State<IotProvisioningScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<IotProvisioningBloc>().add(PairBleDeviceEvent(widget.qrData));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<IotProvisioningBloc, IotProvisioningState>(
//         listener: (context, state) {
//           if (state is BlePairingSuccess) {
//             context.pushNamed(
//               AppRouteConstants.ioTProvisioningEnterWifiCredentials,
//               extra: state.device,
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
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset('assets/animations/ble_searching.json'),
//                     const SizedBox(height: 20),
//                     Text(
//                       state is BlePairingInProgress
//                           ? 'Searching for your device...'
//                           : state is BlePairingFailure
//                               ? 'Failed to pair: ${state.error}'
//                               : 'Starting pairing process...',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                             color: Colors.white,
//                           ),
//                       textAlign: TextAlign.center,
//                     ),
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
