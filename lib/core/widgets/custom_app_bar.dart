import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bhakti_setu/core/theme/app_colors.dart'; // Make sure this path is correct!

class PremiumGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // Optional: In case you need buttons on the right side later

  const PremiumGlassAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: actions,
      iconTheme: const IconThemeData(color: AppColors.textPrimary), 
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}