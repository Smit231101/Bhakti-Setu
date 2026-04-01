import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumGlassAppBar(title: "Login Here"),
    );
  }
}