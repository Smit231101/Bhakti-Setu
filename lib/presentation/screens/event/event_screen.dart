import 'dart:ui';
import 'package:bhakti_setu/presentation/screens/event/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bhakti_setu/core/theme/app_colors.dart';
import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:bhakti_setu/presentation/providers/event_provider.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EventProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const PremiumGlassAppBar(title: "Upcoming Events"),
      extendBodyBehindAppBar: true,
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.isLoading) {
            return _buildLoadingState();
          }

          if (eventProvider.error != null) {
            return _buildErrorState(eventProvider.error!);
          }

          if (eventProvider.events.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.only(
              top: topPadding,
              left: 16,
              right: 16,
              bottom: 32,
            ),
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              final event = eventProvider.events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PremiumEventCard(event: event, index: index),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
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
              Icons.event_busy_rounded,
              size: 48,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No upcoming events",
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Check back later for updates from the Mandir.",
            style: GoogleFonts.poppins(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PremiumEventCard extends StatefulWidget {
  final dynamic event;
  final int index;

  const _PremiumEventCard({required this.event, required this.index});

  @override
  State<_PremiumEventCard> createState() => _PremiumEventCardState();
}

class _PremiumEventCardState extends State<_PremiumEventCard>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
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
    final bool isImportant = widget.event.isImportant;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 650),
      curve: Interval(
        (widget.index * 0.1).clamp(0.0, 1.0),
        1.0,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.reverse(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(18), // More breathing room
            decoration: BoxDecoration(
              // Premium Suble Gradient Surface
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isImportant
                    ? [
                        AppColors.surfaceLight,
                        AppColors.primaryOrange.withOpacity(
                          0.05,
                        ), // Faint orange tint
                      ]
                    : [AppColors.surfaceLight, AppColors.scaffoldBackground],
              ),
              borderRadius: BorderRadius.circular(
                24,
              ), // Smoother, rounder edges
              border: Border.all(
                color: isImportant
                    ? AppColors.primaryOrange.withOpacity(0.6)
                    : AppColors.glassBorder.withOpacity(0.05),
                width: isImportant ? 1.5 : 1,
              ),
              // Ambient Glow for Important Events
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
                if (isImportant)
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.15),
                    blurRadius: 30, // Wide, soft glowing effect
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align to top
              children: [
                // Premium Icon Block
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isImportant
                          ? [AppColors.primaryOrange, AppColors.secondaryOrange]
                          : [
                              AppColors.surfaceLight,
                              Colors.white.withOpacity(0.05),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isImportant
                          ? Colors.transparent
                          : AppColors.glassBorder.withOpacity(0.1),
                    ),
                    boxShadow: isImportant
                        ? [
                            BoxShadow(
                              color: AppColors.primaryOrange.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    Icons.event_note_rounded,
                    color: isImportant ? Colors.white : AppColors.textMuted,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Content Stack
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Optional Star
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.event.title,
                              style: GoogleFonts.poppins(
                                color: AppColors.textPrimary,
                                fontWeight: isImportant
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 17,
                                letterSpacing: 0.2,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isImportant) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: AppColors.accentGold,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildInfoChip(
                            icon: Icons.calendar_month_rounded,
                            text: widget.event.date,
                            isImportant: isImportant,
                          ),
                          _buildInfoChip(
                            icon: Icons.location_on_rounded,
                            text: widget.event.venue,
                            isImportant: false,
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
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required bool isImportant,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isImportant
            ? AppColors.primaryOrange.withOpacity(0.1)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isImportant
              ? AppColors.primaryOrange.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isImportant ? AppColors.primaryOrange : AppColors.textMuted,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: isImportant
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isImportant ? FontWeight.w500 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
