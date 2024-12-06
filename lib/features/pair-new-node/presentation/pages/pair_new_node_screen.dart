// lib/features/pairnewnode/presentation/screens/pair_new_node_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/pair-new-node/presentation/bloc/pair_new_node_bloc.dart';
import 'package:stapes_home/features/pair-new-node/presentation/bloc/pair_new_node_event.dart';
import 'package:stapes_home/features/pair-new-node/presentation/bloc/pair_new_node_state.dart';

class PairNewNodeScreen extends StatelessWidget {
  final String deviceName;
  final String serviceUuid;
  final String configCharacteristicUuid;
  final String versionCharacteristicUuid;
  final String roomId;
  final String userId;
  final String sessionId;

  const PairNewNodeScreen({
    Key? key,
    required this.deviceName,
    required this.serviceUuid,
    required this.configCharacteristicUuid,
    required this.versionCharacteristicUuid,
    required this.roomId,
    required this.userId,
    required this.sessionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PairNewNodeBloc(
        pairBluetoothDeviceUseCase: context.read(),
        sendWifiCredentialsUseCase: context.read(),
      )..add(StartPairingEvent(deviceName: deviceName, serviceUuid: serviceUuid)),
      child: BlocConsumer<PairNewNodeBloc, PairNewNodeState>(
        listener: (context, state) {
          if (state is PairNewNodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PairNewNodeBluetoothPaired) {
            // Navigate to Wi-Fi Credentials Screen or show input
            // context.read<PairNewNodeBloc>().add(SendWifiCredentialsEvent(...));
          } else if (state is PairNewNodeWifiCredentialsSent) {
            // Navigate to Name Node Screen or show input
            // context.read<PairNewNodeBloc>().add(NameNodeEvent(...));
          } else if (state is PairNewNodeCompleted) {
            // Pairing completed, navigate to next screen
          }
        },
        builder: (context, state) {
          if (state is PairNewNodeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PairNewNodeInitial) {
            return Center(child: Text('Initializing Pairing...'));
          } else if (state is PairNewNodeBluetoothPaired) {
            return Center(child: Text('Bluetooth Device Paired'));
          } else if (state is PairNewNodeWifiCredentialsSent) {
            return Center(child: Text('Wi-Fi Credentials Sent'));
          } else if (state is PairNewNodeNamed) {
            return Center(child: Text('Node Named Successfully'));
          } else if (state is PairNewNodeCompleted) {
            return Center(child: Text('Pairing Completed'));
          } else {
            return Center(child: Text('Pairing'));
          }
        },
      ),
    );
  }
}