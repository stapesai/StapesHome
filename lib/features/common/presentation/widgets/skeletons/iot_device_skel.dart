// File: lib/features/common/presentation/widgets/skeletons/iot_device_skel.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IotDevicesSkeleton extends StatefulWidget {
  final double width;
  final double height;

  const IotDevicesSkeleton({
    super.key,
    this.width = 150,
    this.height = 150,
  });

  @override
  createState() => _DevicesSkeletonState();
}

class _DevicesSkeletonState extends State<IotDevicesSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Color(0xFF2A2A2A),
      end: Color(0xFF3A3A3A),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color(0xFF1D1D1D),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 68.w,
                height: 68.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorAnimation.value,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: 80.w,
                height: 16.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _colorAnimation.value,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
