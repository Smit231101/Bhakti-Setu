import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthProvider, Object?>((provider) => provider.user);

    if (user != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
