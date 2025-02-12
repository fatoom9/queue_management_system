import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF335A7B);
const Color secondaryColor = Color(0xFFf1f2ed);
const Color accentColor = Color(0xFFAD534A);

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.helpText,
    required this.obscureText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.textColor = primaryColor,
    this.fillColor = primaryColor,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String helpText;
  final bool obscureText;
  final IconData icon;
  final TextInputType keyboardType;
  final Color textColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: textColor, width: 1.5),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        helperText: helpText,
        helperStyle: TextStyle(color: textColor),
        prefixIcon: Icon(icon, color: textColor),
        filled: true,
        fillColor: fillColor.withOpacity(0.1),
      ),
    );
  }
}
