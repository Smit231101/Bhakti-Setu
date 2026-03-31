import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:bhakti_setu/core/theme/app_colors.dart';
import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:bhakti_setu/presentation/providers/donor_provider.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({super.key});

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DonorProvider>().loadDonors();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic padding so content flows behind the blurred app bar
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDeep, // Deep classic background
      extendBodyBehindAppBar: true, // Required for PremiumGlassAppBar
      appBar: const PremiumGlassAppBar(title: "Donors of Mandir"),
      body: Consumer<DonorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }
          if (provider.error != null) {
            return _buildErrorState(provider.error!);
          }
          if (provider.donors.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.only(
              top: topPadding,
              left: 16,
              right: 16,
              bottom: 32,
            ),
            itemCount: provider.donors.length,
            itemBuilder: (context, index) {
              final donor = provider.donors[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PremiumDonorCard(donor: donor, index: index),
              );
            },
          );
        },
      ),
    );
  }

  // --- PREMIUM STATES ---

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.error.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            error,
            style: GoogleFonts.poppins(
              color: AppColors.error,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.volunteer_activism_rounded,
              size: 48,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Donors Yet",
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Be the first to contribute to the Mandir.",
            style: GoogleFonts.poppins(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// --- PREMIUM DONOR CARD WIDGET ---

class _PremiumDonorCard extends StatefulWidget {
  final dynamic donor;
  final int index;

  const _PremiumDonorCard({required this.donor, required this.index});

  @override
  State<_PremiumDonorCard> createState() => _PremiumDonorCardState();
}

class _PremiumDonorCardState extends State<_PremiumDonorCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Top 3 donors get a special gold highlight
    final bool isTopDonor = widget.index < 3;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Interval(
        (widget.index * 0.1).clamp(0.0, 1.0),
        1.0,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              gradient: isTopDonor
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.surfaceLight,
                        AppColors.accentGold.withOpacity(0.05),
                      ],
                    )
                  : null,
              border: Border.all(
                color: isTopDonor
                    ? AppColors.accentGold.withOpacity(0.3)
                    : AppColors.glassBorder.withOpacity(0.05),
                width: isTopDonor ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isTopDonor
                      ? AppColors.accentGold.withOpacity(0.1)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Classic Graphics: Ambient Watermark
                Positioned(
                  right: -10,
                  top: -10,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(
                      Icons.volunteer_activism_rounded,
                      size: 80,
                      color: Colors.white.withOpacity(0.02),
                    ),
                  ),
                ),

                // Foreground Content
                Row(
                  children: [
                    // Premium Avatar Block
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isTopDonor
                              ? [
                                  AppColors.accentGold,
                                  Color(0xFFB8860B),
                                ] // Rich gold
                              : [
                                  AppColors.primaryOrange,
                                  AppColors.secondaryOrange,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isTopDonor
                                        ? AppColors.accentGold
                                        : AppColors.primaryOrange)
                                    .withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.donor.name.isNotEmpty
                              ? widget.donor.name[0].toUpperCase()
                              : "?",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Donor Name & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.donor.name,
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: isTopDonor
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isTopDonor ? "Top Contributor" : "Generous Donor",
                            style: GoogleFonts.poppins(
                              color: isTopDonor
                                  ? AppColors.accentGold.withOpacity(0.8)
                                  : AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Premium Amount Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldDeep.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.glassBorder.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "₹",
                            style: GoogleFonts.poppins(
                              color: AppColors.accentGold,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.donor.amount.toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
