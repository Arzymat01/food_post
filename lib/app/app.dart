import 'package:flutter/material.dart';
import 'package:food_post/core/services/auth_service.dart';
import 'package:food_post/features/auth/auth_controller.dart';
import 'package:food_post/features/auth/login_page.dart';
import 'package:provider/provider.dart';

class OrderFlowApp extends StatelessWidget {
  const OrderFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => AuthController(context.read<AuthService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OrderFlow POS',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
        home: const LoginPage(),
      ),
    );
  }
}
