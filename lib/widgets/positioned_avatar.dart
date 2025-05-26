import 'package:flutter/material.dart';

class PositionedAvatar extends StatelessWidget {
  final double left;
  final String imagePath;
  final double radius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final Widget? child;

  const PositionedAvatar({
    super.key,
    this.left = 0,
    required this.imagePath,
    this.radius = 16,
    this.border,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: border,
          color: backgroundColor,
        ),
        child:
            child ??
            CircleAvatar(
              radius: radius,
              backgroundImage: Image.asset(imagePath).image,
            ),
      ),
    );
  }
}
