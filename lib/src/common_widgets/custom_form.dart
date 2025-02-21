import 'package:flutter/material.dart';
import 'package:queue_management_system/src/common_widgets/text_feild.dart';

// Email Validator
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  RegExp regExp = RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

// Password Validator
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 10) {
    return 'Password must be at least 10 characters';
  }
  return null;
}

// Form Widget
class FormValidationWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const FormValidationWidget({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  _FormValidationWidgetState createState() => _FormValidationWidgetState();
}

class _FormValidationWidgetState extends State<FormValidationWidget> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Input Field
          AppTextFormField(
            controller: widget.emailController,
            hintText: 'Enter your email',
            helpText: '',
            obscureText: false,
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          // Password Input Field
          AppTextFormField(
            controller: widget.passwordController,
            hintText: 'Enter your password',
            helpText: '',
            obscureText: true,
            icon: Icons.lock,
          ),
        ],
      ),
    );
  }
}
