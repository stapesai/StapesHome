import 'package:flutter/material.dart';

class NodeComponentSkeleton extends StatefulWidget {
  const NodeComponentSkeleton({super.key});

  @override
  createState() => _NodeComponentSkeletonState();
}


class _NodeComponentSkeletonState extends State<NodeComponentSkeleton> with SingleTickerProviderStateMixin {
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
          width: double.infinity,
          height: 68.72,
          margin: EdgeInsets.only(bottom: 19.63),
          padding: EdgeInsets.symmetric(horizontal: 20.62, vertical: 2.95),
          decoration: ShapeDecoration(
            color: Color(0xFF1D1D1D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.45),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 39.27,
                    height: 39.27,
                    decoration: ShapeDecoration(
                      color: _colorAnimation.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29.45),
                      ),
                    ),
                  ),
                  SizedBox(width: 9.82),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 19.63,
                        color: _colorAnimation.value,
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 9.82,
                        color: _colorAnimation.value,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
