import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stapes_home/core/models/device_model.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/common/widgets/input/textfield.dart';
import 'package:stapes_home/features/devices/data/models/create_device_api_param.dart';
import 'package:stapes_home/features/devices/domain/usecases/create_device_usecase.dart';
import 'package:stapes_home/features/devices/presentation/pages/devices.dart';
import 'package:stapes_home/service_locator.dart';

class AddNewDevicePage extends StatefulWidget {
  const AddNewDevicePage({super.key});

  @override
  State<AddNewDevicePage> createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends State<AddNewDevicePage> {
  final TextEditingController nodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController channelIdController = TextEditingController();

  @override
  void dispose() {
    nodeController.dispose();
    nameController.dispose();
    typeController.dispose();
    channelIdController.dispose();
    super.dispose();
  }

  Future<void> _createDevice(BuildContext ctx) async {
    if (nodeController.text.isEmpty ||
        nameController.text.isEmpty ||
        typeController.text.isEmpty ||
        channelIdController.text.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    // Validate channelId is numeric
    final channelId = int.tryParse(channelIdController.text);
    if (channelId == null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Channel ID must be a number')),
      );
      return;
    }

    final device = DeviceModel(
      id: null,
      nodeId: nodeController.text,
      name: nameController.text,
      type: typeController.text,
      channelId: channelId,
    );

    final result = await serviceLocator<CreateDeviceUseCase>()(
      CreateDevicesParams(device: device),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        Navigator.pushReplacement(
          ctx,
          MaterialPageRoute(builder: (_) => const DevicesPage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.backgroundColorgradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a new device',
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Enter the details for adding a device',
                  style: TextStyle(
                    color: AppColor.whiteColor50,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  hintText: 'Node ID',
                  controller: nodeController,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: 'Device Name',
                  controller: nameController,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: 'Device Type',
                  controller: typeController,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: 'Channel ID',
                  controller: channelIdController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.iconBarColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () => _createDevice(context),
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
