import 'package:flutter/material.dart';
import 'package:queue_management_system/src/common_widgets/button.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color color;
  final Color backgroundColor;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.color = Colors.white,
    this.backgroundColor = primaryColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: IconButton(
        icon: Icon(icon, size: size, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
