import 'dart:convert';
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/widgets/button.dart';
import 'package:StapesHome/widgets/input/dropdown.dart';
import 'package:StapesHome/widgets/input/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNewDevicePage extends StatefulWidget {
  final String userId;
  final String sessionId;

  const AddNewDevicePage({
    super.key,
    required this.userId,
    required this.sessionId,
  });

  @override
  createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevicePage> {
  String? _selectedFloorId;
  String? _selectedRoomId;
  String? _selectedNodeId;
  String? _selectedDeviceType;
  int? _selectedChannelId;

  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController channelIdController = TextEditingController();

  List<Floor> floors = [];
  List<Room> rooms = [];
  List<Node> nodes = [];
  final List<String> _deviceTypes = ['light', 'fan'];
  final List<int> _channelIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFloors();
  }

  Future<void> _fetchFloors() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        BackendRoutes.getFloors,
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> floorsData = json.decode(response.body);
        setState(() {
          floors = floorsData.map((floor) => Floor.fromJson(floor)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load floors: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error fetching floors: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchRooms(String floorId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        BackendRoutes.getRoomsByFloorId(floorId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> roomsData = json.decode(response.body);
        setState(() {
          rooms = roomsData.map((room) => Room.fromJson(room)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching rooms: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchNodes(String roomId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        BackendRoutes.getNodesByRoomId(roomId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> nodesData = json.decode(response.body);
        setState(() {
          nodes = nodesData.map((node) => Node.fromJson(node)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load nodes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching nodes: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _createDevice() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        BackendRoutes.createEntity,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
        body: json.encode({
          'node_id': _selectedNodeId,
          'name': deviceNameController.text,
          'type': _selectedDeviceType,
          'channel_id': _selectedChannelId,
        }),
      );

      if (response.statusCode == 201) {
        // Device created successfully
        // You can add the logic to navigate to the devices page here
      } else {
        throw Exception('Failed to create device: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error creating device: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: AppPadding.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  Text(
                    'Add a new device',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: AppFontSizes.pageHeading,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Enter the details for adding a new device.',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: AppFontSizes.pageSubHeading,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          NDropdown<String>(
                            hintText: 'Floor',
                            value: _selectedFloorId,
                            items: floors.map((floor) {
                              return DropdownMenuItem<String>(
                                value: floor.id,
                                child: Text(floor.alias),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFloorId = newValue;
                                _selectedRoomId = null;
                                _selectedNodeId = null;
                                rooms.clear();
                                nodes.clear();
                              });
                              if (newValue != null) {
                                _fetchRooms(newValue);
                              }
                            },
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          NDropdown<String>(
                            hintText: 'Room',
                            value: _selectedRoomId,
                            items: rooms.map((room) {
                              return DropdownMenuItem<String>(
                                value: room.id,
                                child: Text(room.name),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRoomId = newValue;
                                _selectedNodeId = null;
                                nodes.clear();
                              });
                              if (newValue != null) {
                                _fetchNodes(newValue);
                              }
                            },
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          NDropdown<String>(
                            hintText: 'Node',
                            value: _selectedNodeId,
                            items: nodes.map((node) {
                              return DropdownMenuItem<String>(
                                value: node.id,
                                child: Text(node.name),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedNodeId = newValue;
                              });
                            },
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          NTextField(
                            hintText: 'Device Name',
                            controller: deviceNameController,
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          NDropdown<String>(
                            hintText: 'Device Type',
                            value: _selectedDeviceType,
                            items: _deviceTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDeviceType = newValue;
                              });
                            },
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          NDropdown(
                            hintText: 'Channel Id',
                            value: _selectedChannelId,
                            items: _channelIds.map((int channelId) {
                              return DropdownMenuItem<int>(
                                value: channelId,
                                child: Text(channelId.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedChannelId = newValue;
                              });
                            },
                          ),
                          SizedBox(height: screenSize.height * 0.06),
                        ],
                      ),
                    ),
                  ),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      bottom: keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.02 : screenSize.height * 0.1,
                    ),
                    child: Center(
                      child: CustomButton(
                        text: "Create",
                        onPressed: _createDevice,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
