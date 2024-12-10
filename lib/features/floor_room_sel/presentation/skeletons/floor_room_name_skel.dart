// File: lib/features/floor_room_sel/presentation/skeletons/floor_room_name_skel.dart

import 'package:flutter/material.dart';

class FloorRoomNameButtonSkeleton extends StatefulWidget {
  final double width;
  final double height;

  const FloorRoomNameButtonSkeleton({
    super.key,
    this.width = 80,
    this.height = 30,
  });

  @override
  createState() => _FloorRoomNameButtonSkeletonState();
}

class _FloorRoomNameButtonSkeletonState extends State<FloorRoomNameButtonSkeleton> with SingleTickerProviderStateMixin {
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
      begin: Colors.grey.withOpacity(0.3),
      end: Colors.grey.withOpacity(0.5),
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
        return Column(
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _colorAnimation.value,
              ),
            ),
          ],
        );
      },
    );
  }
}
