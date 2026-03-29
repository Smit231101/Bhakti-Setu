import 'package:bhakti_setu/presentation/screens/home/dashboard_screen.dart';
import 'package:flutter/material.dart';
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
              bottom: 24,
            ),
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              final event = eventProvider.events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 40,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: GoogleFonts.poppins(color: AppColors.error, fontSize: 14),
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 40,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No upcoming events",
            style: GoogleFonts.poppins(
              color: AppColors.textMuted,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
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
      duration: const Duration(milliseconds: 150),
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

  @override
  Widget build(BuildContext context) {
    final bool isImportant = widget.event.isImportant;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
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
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.reverse(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isImportant
                    ? AppColors.primaryOrange.withOpacity(0.5)
                    : AppColors.glassBorder.withOpacity(0.05),
                width: isImportant ? 1.5 : 1,
              ),
              boxShadow: isImportant
                  ? [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: isImportant
                        ? AppColors.primaryOrange.withOpacity(0.15)
                        : AppColors.textPrimary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.event_note_rounded,
                    color: isImportant
                        ? AppColors.primaryOrange
                        : AppColors.textMuted,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: GoogleFonts.poppins(
                          color: AppColors.textPrimary,
                          fontWeight: isImportant
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "${widget.event.date} • ${widget.event.venue}",
                              style: GoogleFonts.poppins(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing Icon
                const SizedBox(width: 12),
                if (isImportant)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: AppColors.primaryOrange,
                      size: 16,
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textPrimary.withOpacity(0.2),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
