import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:bhakti_setu/core/theme/app_colors.dart';
import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:bhakti_setu/presentation/providers/auth_provider.dart';
import 'package:bhakti_setu/presentation/screens/home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // High-end UX: Listen for focus changes to animate the input field's glow
    otpFocusNode.addListener(() {
      setState(() {
        _isFocused = otpFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  void _showPremiumSnackbar(String message, {bool isError = false}) {
    if (isError) HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: isError
            ? AppColors.error.withOpacity(0.9)
            : AppColors.surfaceLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isError
                ? AppColors.error
                : AppColors.glassBorder.withOpacity(0.1),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(20),
        elevation: 20,
      ),
    );
  }

  Future<void> _handleVerify(AuthProvider provider) async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      _showPremiumSnackbar(
        "Please enter the complete 6-digit OTP",
        isError: true,
      );
      otpFocusNode.requestFocus();
      return;
    }

    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    final success = await provider.verifyOtp(otp);

    if (!mounted) return;

    if (!success) {
      _showPremiumSnackbar(
        provider.error ?? "Invalid OTP entered.",
        isError: true,
      );
      otpController.clear();
      otpFocusNode.requestFocus();
      return;
    }

    // Success!
    HapticFeedback.mediumImpact();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldDeep,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. Classical Graphic Parallax Background
          _buildAmbientBackground(),

          // 2. Foreground Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The Classical Security Emblem
                    _buildSecurityEmblem(),
                    const SizedBox(height: 32),

                    // Royal Typography
                    Text(
                      "Verify OTP",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Enter the 6-digit code sent to your\nmobile number to authenticate.",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppColors.textSecondary.withOpacity(0.8),
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Ultra-Premium Glassmorphism Card
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Dynamic Glowing OTP Input Field
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            decoration: BoxDecoration(
                              color: _isFocused
                                  ? AppColors.scaffoldBackground.withOpacity(
                                      0.8,
                                    )
                                  : AppColors.scaffoldDeep.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _isFocused
                                    ? AppColors.primaryOrange.withOpacity(0.6)
                                    : AppColors.glassBorder.withOpacity(0.08),
                                width: _isFocused ? 1.5 : 1.0,
                              ),
                              boxShadow: _isFocused
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryOrange
                                            .withOpacity(0.15),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: TextField(
                              controller: otpController,
                              focusNode: otpFocusNode,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                  6,
                                ), // Firebase standard OTP length
                              ],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing:
                                    16.0, // High letter spacing mimics individual PIN boxes
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: AppColors.primaryOrange,
                              decoration: InputDecoration(
                                hintText: "------",
                                hintStyle: GoogleFonts.poppins(
                                  color: AppColors.textMuted.withOpacity(0.2),
                                  letterSpacing: 16.0,
                                ),
                                border: InputBorder.none,
                                counterText:
                                    "", // Hides the '0/6' text below the field
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Action Button
                          _buildPremiumButton(provider),

                          const SizedBox(height: 24),

                          // Resend Text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't receive the code? ",
                                style: GoogleFonts.poppins(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  _showPremiumSnackbar("Sending a new OTP...");
                                  // TODO: Add your provider.resendOtp() logic here
                                },
                                child: Text(
                                  "Resend",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryOrange,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityEmblem() {
    return Center(
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceLight.withOpacity(0.8),
              AppColors.scaffoldDeep.withOpacity(0.8),
            ],
          ),
          border: Border.all(
            color: AppColors.accentGold.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.lock_person_rounded, // Security/Verification motif
            size: 36,
            color: AppColors.accentGold.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Radial Spotlight
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  AppColors.primaryOrange.withOpacity(0.15),
                  AppColors.scaffoldDeep,
                ],
              ),
            ),
          ),
          // Graphic motif matching the login screen
          Positioned(
            top: -150,
            right: -200,
            child: Transform.rotate(
              angle: 0.2,
              child: Icon(
                Icons.wb_twilight_rounded,
                size: 700,
                color: AppColors.accentGold.withOpacity(0.03),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumButton(AuthProvider provider) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: provider.isLoading ? 0.7 : 1.0,
      child: InkWell(
        onTap: provider.isLoading ? null : () => _handleVerify(provider),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppColors.buttonGradient,
            boxShadow: provider.isLoading
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.4),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: Center(
            child: provider.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Verify & Proceed",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
