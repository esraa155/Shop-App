import 'package:flutter/material.dart';
import 'auth/login_register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      // Don't change locale - keep default English
      // User can change language later from HomeScreen

      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      // Always go to RegisterScreen first (initialMode: false means Register mode)
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const LoginRegisterScreen(initialMode: false)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text('Shop App',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600))));
  }
}

