import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/widgets/button.dart';
import 'package:StapesHome/widgets/input_fields.dart';
import 'package:flutter/material.dart';

class AddNewDevice extends StatefulWidget {
  const AddNewDevice({super.key});

  @override
  createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevice> {
  String? _selectedFloor;
  String? _selectedRoom;
  String? _selectedNode;
  String? _selectedDeviceType;

  final TextEditingController deviceNameController = TextEditingController();
  final TextEditingController channelIdController = TextEditingController();

  final List<String> _floors = ['Floor 1', 'Floor 2', 'Floor 3'];
  final List<String> _rooms = ['Room 1', 'Room 2', 'Room 3'];
  final List<String> _nodes = ['Node 1', 'Node 2', 'Node 3'];
  final List<String> _deviceTypes = ['Type 1', 'Type 2', 'Type 3'];

  Widget _buildDropdown(String hint, List<String> items, String? value, Function(String?) onChanged) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColor.whiteColor50, // Border color
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColor.whiteColor50,
            fontSize: 16,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(color: AppColor.whiteColor)),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: Color(0xFF353841), // Dropdown menu background color
        style: TextStyle(color: AppColor.whiteColor), // Text color inside dropdown
        icon: Icon(Icons.arrow_drop_down, color: AppColor.whiteColor), // Dropdown icon
      ),
    );
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
                  SizedBox(height: screenSize.height * 0.08),
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
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildDropdown('Floor', _floors, _selectedFloor, (newValue) {
                            setState(() {
                              _selectedFloor = newValue;
                            });
                          }),
                          SizedBox(height: screenSize.height * 0.02),
                          _buildDropdown('Room', _rooms, _selectedRoom, (newValue) {
                            setState(() {
                              _selectedRoom = newValue;
                            });
                          }),
                          SizedBox(height: screenSize.height * 0.02),
                          _buildDropdown('Node', _nodes, _selectedNode, (newValue) {
                            setState(() {
                              _selectedNode = newValue;
                            });
                          }),
                          SizedBox(height: screenSize.height * 0.02),
                          NTextField(
                            hintText: 'Device Name',
                            controller: deviceNameController,
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          _buildDropdown('Device Type', _deviceTypes, _selectedDeviceType, (newValue) {
                            setState(() {
                              _selectedDeviceType = newValue;
                            });
                          }),
                          SizedBox(height: screenSize.height * 0.02),
                          NTextField(
                            hintText: 'Channel Id',
                            controller: channelIdController,
                          ),
                          SizedBox(height: screenSize.height * 0.06),
                        ],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      bottom: keyboardHeight > 0 ? keyboardHeight : screenSize.height * 0.02,
                    ),
                    child: Center(
                      child: CustomButton(
                        text: "Create",
                        onPressed: () {
                          // Handle create button press
                        },
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
