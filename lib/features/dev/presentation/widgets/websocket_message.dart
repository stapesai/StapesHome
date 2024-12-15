import 'package:flutter/material.dart';
import 'package:stapes_home/core/websocket/websocket_messages_models.dart';

class MessageCard extends StatelessWidget {
  final String page;
  final String title;
  final Color borderColor;
  final Color backgroundColor;
  final List<MapEntry<String, String>> details;
  final Animation<double> animation;

  const MessageCard({
    super.key,
    required this.page,
    required this.title,
    required this.borderColor,
    required this.backgroundColor,
    required this.details,
    required this.animation,
  });

  @override
  StatelessElement createElement() {
    print('Creating MessageCard for $title on $page');
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: borderColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          color: borderColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          details.length,
          (index) => _buildDetailRow(
            details[index].key,
            details[index].value,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: borderColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceStatusUpdateWidget extends StatelessWidget {
  final String page;
  final WebsocketDeviceStatusUpdate data;
  final Animation<double> animation;

  const DeviceStatusUpdateWidget({
    super.key,
    required this.page,
    required this.data,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      key: key,
      page: page,
      title: 'Device Status Update',
      borderColor: Colors.blue,
      backgroundColor: Colors.blue.withOpacity(0.1),
      animation: animation,
      details: [
        MapEntry('Device ID', data.deviceId),
        MapEntry('State', data.state.toString()),
      ],
    );
  }
}

class NodeStatusUpdateWidget extends StatelessWidget {
  final String page;
  final WebsocketNodeStatusUpdate data;
  final Animation<double> animation;

  const NodeStatusUpdateWidget({
    super.key,
    required this.page,
    required this.data,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      key: key,
      page: page,
      title: 'Node Status Update',
      borderColor: Colors.yellow,
      backgroundColor: Colors.yellow.withOpacity(0.1),
      animation: animation,
      details: [
        MapEntry('Node ID', data.nodeId),
        MapEntry('Status', data.isOnline ? 'Online' : 'Offline'),
        if (data.lastSeen != null) MapEntry('Last Seen', data.lastSeen.toString()),
      ],
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  final String page;
  final WebsocketErrorMessage data;
  final Animation<double> animation;

  const ErrorMessageWidget({
    super.key,
    required this.page,
    required this.data,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      key: key,
      page: page,
      title: 'Error Message',
      borderColor: Colors.red,
      backgroundColor: Colors.red.withOpacity(0.1),
      animation: animation,
      details: [
        MapEntry('Details', data.details),
      ],
    );
  }
}
