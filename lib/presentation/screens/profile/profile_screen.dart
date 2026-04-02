import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:bhakti_setu/core/theme/app_colors.dart';
import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:bhakti_setu/presentation/providers/auth_provider.dart';
import 'package:bhakti_setu/presentation/screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 32;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDeep,
      extendBodyBehindAppBar: true,
      appBar: const PremiumGlassAppBar(title: "My Profile"),
      body: Stack(
        children: [
          _buildAmbientBackground(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: topPadding,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeroCard(user?.phoneNumber ?? "No Number"),
                const SizedBox(height: 40),
                _buildQuoteCard(),
                const SizedBox(height: 40),
                _buildLogoutButton(context, authProvider),
              ],
            ),
          ),
        ],
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
                center: const Alignment(0, -0.4),
                radius: 1.0,
                colors: [
                  AppColors.primaryOrange.withOpacity(0.12),
                  AppColors.scaffoldDeep,
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: -100,
            child: Transform.rotate(
              angle: 0.1,
              child: Icon(
                Icons.account_circle_rounded,
                size: 500,
                color: AppColors.accentGold.withOpacity(0.02),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeroCard(String phoneNumber) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.7),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: AppColors.surfaceLight, width: 4),
            ),
            child: const Center(
              child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Welcome, Devotee",
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.scaffoldDeep.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.glassBorder.withOpacity(0.05),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.accentGold,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  phoneNumber,
                  style: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.accentGold.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColors.accentGold.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            "\"For one who has conquered the mind, the mind is the best of friends.\"",
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: Colors.white.withOpacity(0.9),
              fontSize: 20,
              fontStyle: FontStyle.italic,
              height: 1.6,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "BHAGAVAD GITA",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.accentGold.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          HapticFeedback.mediumImpact();
          await authProvider.logout();
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.error.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                "Secure Logout",
                style: GoogleFonts.poppins(
                  color: AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
