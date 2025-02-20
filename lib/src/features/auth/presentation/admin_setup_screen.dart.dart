import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/common_widgets/button.dart'
    as button;
import 'package:queue_management_system/src/common_widgets/text_feild.dart';
import 'package:queue_management_system/src/constants/app_theme.dart';
import 'package:queue_management_system/src/features/auth/presentation/controllers/auth_controller.dart';

class AdminSetupScreen extends HookConsumerWidget {
  const AdminSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final auth = ref.read(authControllerProvider.notifier);
    void createAdmin() async {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and password cannot be empty.')),
        );
        return;
      }
      isLoading.value = true;
      await auth.createAdmin(emailController.text, passwordController.text);
      isLoading.value = false;
      emailController.clear();
      passwordController.clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin created successfully!')),
        );
        context.goNamed('welcome');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Admin',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor, // Use primaryColor from your theme
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF1F2ED), Color(0xFFF1F2ED)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 18),
                Image.asset(
                  'assets/logo/logo.png',
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      AppTextFormField(
                        controller: emailController,
                        hintText: 'Email',
                        helpText: 'Enter your email address',
                        obscureText: false,
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 16),
                      AppTextFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        helpText: 'Enter your password',
                        obscureText: true,
                        icon: Icons.lock,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading.value ? null : createAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF335A7B),
                          side: BorderSide(color: AppTheme.theme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF335A7B),
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: AppTheme.theme.scaffoldBackgroundColor,
                                  fontSize: 16.5, //
                                  fontWeight: FontWeight.bold, //
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      button.Btn(
                        onPress: () {
                          context.goNamed('adminList');
                        },
                        text: 'View Admin List',
                        backgroundColor: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      button.Btn(
                        onPress: () {
                          context.goNamed('welcome');
                        },
                        text: 'Back',
                        backgroundColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading.value)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
