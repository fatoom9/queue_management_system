import 'package:flutter/material.dart';

class Utils {
  static getTF(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(),
    );
  }
}
