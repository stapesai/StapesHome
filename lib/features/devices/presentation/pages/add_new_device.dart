import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/common/widgets/input/textfield.dart';

class AddNewDevicePage extends StatelessWidget {
  const AddNewDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorDark,
      body: SafeArea(
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
              CustomTextField(hintText: 'Floor'),
              SizedBox(height: 12.h),
              CustomTextField(hintText: 'Room'),
              SizedBox(height: 12.h),
              CustomTextField(hintText: 'Node'),
              SizedBox(height: 12.h),
              CustomTextField(hintText: 'Device Name'),
              SizedBox(height: 12.h),
              CustomTextField(hintText: 'Device Type'),
              SizedBox(height: 12.h),
              CustomTextField(hintText: 'Channel ID'),
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
                  onPressed: () {
                    // Handle Create button
                  },
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
    );
  }
}
