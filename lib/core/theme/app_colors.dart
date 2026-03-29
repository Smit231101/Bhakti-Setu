import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation of this class
  AppColors._();

  // -----------------------------------------
  // Backgrounds & Surfaces (Dark Theme)
  // -----------------------------------------
  static const Color scaffoldBackground = Color(0xFF121212); // Main app background
  static const Color scaffoldDeep = Color(0xFF0A0A0A);       // Deeper background for contrast
  static const Color surfaceLight = Color(0xFF1E1E1E);       // Cards, search bars, list items
  static const Color glassBorder = Colors.white24;           // For glassmorphism borders

  // -----------------------------------------
  // Brand Accents (Oranges & Golds)
  // -----------------------------------------
  static const Color primaryOrange = Color(0xFFFF8A00);
  static const Color secondaryOrange = Color(0xFFFF6A00);
  static const Color accentGold = Color(0xFFFFD700);         // Used for premium stars/badges

  // -----------------------------------------
  // Premium Gradient Colors (The Classic Look)
  // -----------------------------------------
  static const Color gradientOrange = Color(0xFFD35400);     // Rich burnt orange
  static const Color gradientPurple = Color(0xFF8E44AD);     // Deep elegant purple

  // -----------------------------------------
  // Text Colors
  // -----------------------------------------
  static const Color textPrimary = Colors.white;             // Main titles
  static const Color textSecondary = Colors.white70;         // Subtitles
  static const Color textMuted = Colors.white54;             // Empty states, hints

  // -----------------------------------------
  // Feedback & Status
  // -----------------------------------------
  static const Color error = Colors.redAccent;
  static const Color success = Colors.greenAccent;

  // -----------------------------------------
  // Pre-defined Gradients for easy access
  // -----------------------------------------
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [gradientOrange, gradientPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryOrange, secondaryOrange],
  );
}