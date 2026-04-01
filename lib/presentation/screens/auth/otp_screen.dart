import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: PremiumGlassAppBar(title: "Varify your OTP here"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter OTP"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final success = await provider.verifyOtp(otpController.text);

                if (success) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                }
              },
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
