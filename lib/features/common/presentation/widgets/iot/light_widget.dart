// File: lib/features/common/presentation/widgets/iot/light.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/device_model.dart';

class LightComponentWidget extends StatelessWidget {
  final DeviceModel device;
  final bool isActivated;
  final bool isEnabled;
  final Function()? onToggle;

  const LightComponentWidget({
    super.key,
    required this.device,
    required this.isActivated,
    required this.isEnabled,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? onToggle
          : () {
              // Show message when trying to control offline device
              CustomSnackbar(
                context,
                'Device cannot be controlled while node is offline',
                type: SnackbarType.error,
              );
            },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Color(0xFF1D1D1D),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: isActivated ? Color(0xCCFF9F1C) : Colors.transparent,
              blurRadius: 16,
              offset: Offset(8, 7),
              spreadRadius: -3,
            ),
          ],
        ),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Color(0xFF1D1D1D),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: isActivated && isEnabled ? Color(0xCCFF9F1C) : Colors.transparent,
                blurRadius: 16,
                offset: Offset(8, 7),
                spreadRadius: -3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActivated && isEnabled ? Color(0xFFFFA52D) : Colors.white.withOpacity(0.5),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/devices/light.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                device.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
