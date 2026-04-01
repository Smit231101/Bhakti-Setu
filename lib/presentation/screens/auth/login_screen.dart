import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:bhakti_setu/core/theme/app_colors.dart';
import 'package:bhakti_setu/presentation/providers/auth_provider.dart';
import 'package:bhakti_setu/presentation/screens/auth/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    phoneFocusNode.addListener(() {
      setState(() {
        _isFocused = phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    phoneFocusNode.dispose();
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

  Future<void> _handleLogin(AuthProvider provider) async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      _showPremiumSnackbar(
        "Please enter a valid 10-digit phone number",
        isError: true,
      );
      phoneFocusNode.requestFocus();
      return;
    }

    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    await provider.sendOtp("+91$phone");

    if (!mounted) return;

    if (provider.error != null) {
      _showPremiumSnackbar(provider.error!, isError: true);
      return;
    }

    if (provider.user != null) {
      _showPremiumSnackbar("Phone number automatically verified");
      return;
    }

    if (provider.verificationId != null) {
      _showPremiumSnackbar("OTP sent successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OtpScreen()),
      );
    }
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
      ),
      body: Stack(
        children: [
          _buildAmbientBackground(),
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
                    _buildClassicalEmblem(),
                    const SizedBox(height: 32),
                    Text(
                      "Welcome",
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
                      "Enter your mobile number to\ncontinue your spiritual journey.",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppColors.textSecondary.withOpacity(0.8),
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
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
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  child: Text(
                                    "+91",
                                    style: GoogleFonts.poppins(
                                      color: _isFocused
                                          ? AppColors.primaryOrange
                                          : AppColors.textSecondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 28,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: phoneController,
                                    focusNode: phoneFocusNode,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 17,
                                      letterSpacing: 2.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    cursorColor: AppColors.primaryOrange,
                                    decoration: InputDecoration(
                                      hintText: "00000 00000",
                                      hintStyle: GoogleFonts.poppins(
                                        color: AppColors.textMuted.withOpacity(
                                          0.2,
                                        ),
                                        letterSpacing: 2.5,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 20,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildPremiumButton(provider),
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

  Widget _buildClassicalEmblem() {
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
            Icons.temple_hindu_rounded,
            size: 38,
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
        onTap: provider.isLoading ? null : () => _handleLogin(provider),
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
                        "Get OTP",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
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
