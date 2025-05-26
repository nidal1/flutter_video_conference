import 'package:flutter/material.dart';

class MoreParticipantsAvatar extends StatelessWidget {
  final double left;
  final String label;
  final Color backgroundColor;
  final BoxBorder? border;

  const MoreParticipantsAvatar({
    super.key,
    this.left = 0,
    required this.label,
    this.backgroundColor = const Color(0xFF263238),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: border,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
