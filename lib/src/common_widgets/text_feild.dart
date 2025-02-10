import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.helpText,
    required this.obscureText,
    required this.icon, //
  });

  final TextEditingController controller;
  final String hintText;
  final String helpText;
  final bool obscureText;
  final IconData icon; //

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF335A7B);
    const Color foregroundColor = Colors.white;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: true,
      style: const TextStyle(color: primaryColor),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: foregroundColor),
        helperText: helpText,
        helperStyle: const TextStyle(color: primaryColor),
        prefixIcon: Icon(icon, color: primaryColor), //
        filled: true,
        fillColor: primaryColor.withOpacity(0.1),
      ),
    );
  }
}
