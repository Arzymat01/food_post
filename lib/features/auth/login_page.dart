import 'package:flutter/material.dart';
import 'package:food_post/core/utils/app_constants.dart';
import 'package:food_post/core/widgets/app_button.dart';
import 'package:food_post/core/widgets/app_text_field.dart';
import 'package:food_post/features/admin/admin_home_page.dart';
import 'package:food_post/features/auth/auth_controller.dart';
import 'package:food_post/features/cashier/cashier_home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    final auth = context.read<AuthController>();
    final user = await auth.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted || user == null) return;

    if (user.role == AppConstants.adminRole) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminHomePage(user: user)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CashierHomePage(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 360,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'OrderFlow POS',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(controller: _usernameController, label: 'Логин'),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Пароль',
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  if (auth.error != null)
                    Text(
                      auth.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: auth.loading ? 'Күтүңүз...' : 'Кирүү',
                    onPressed: auth.loading ? null : _submit,
                    icon: Icons.login,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
