import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:bhakti_setu/presentation/providers/auth_provider.dart';
import 'package:bhakti_setu/presentation/screens/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: PremiumGlassAppBar(title: "Login Here"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Enter Phone (+91XXXXXXXXXX)",
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final phone = phoneController.text.trim();

                if (phone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a phone number"),
                    ),
                  );
                  return;
                }

                await provider.sendOtp(phone);

                if (provider.error != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.error!)),
                  );
                }

                if (provider.verificationId != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OtpScreen()),
                  );
                }
              },
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text("Send OTP", style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }
}
