import 'package:flutter/material.dart';

class FloorRoomNameSkeleton extends StatefulWidget {
  final double width;
  final double height;

  const FloorRoomNameSkeleton({
    super.key,
    this.width = 200,
    this.height = 24,
  });

  @override
  createState() => _FloorRoomNameSkeletonState();
}

class _FloorRoomNameSkeletonState extends State<FloorRoomNameSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Gradient> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _gradientAnimation = Tween<Gradient>(
      begin: LinearGradient(
        colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
        stops: const [0.0, 0.5, 1.0],
      ),
      end: LinearGradient(
        colors: [Colors.grey.shade100, Colors.grey.shade300, Colors.grey.shade100],
        stops: const [0.0, 0.5, 1.0],
      ),
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
      animation: _gradientAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: _gradientAnimation.value,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      },
    );
  }
}
