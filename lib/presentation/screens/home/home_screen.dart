import 'dart:ui';
import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:bhakti_setu/data/services/notifications/notification_service.dart';
import 'package:bhakti_setu/presentation/screens/donor/donor_screen.dart';
import 'package:bhakti_setu/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhakti_setu/core/theme/app_colors.dart';
import 'package:bhakti_setu/presentation/screens/event/event_screen.dart';
import 'package:bhakti_setu/presentation/screens/festival/festival_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService service = NotificationService();

  @override
  void initState() {
    super.initState();
    service.requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = <_HomeMenuItem>[
      _HomeMenuItem(
        title: "Upcoming Events",
        icon: Icons.event,
        builder: (_) => const EventScreen(),
      ),
      _HomeMenuItem(
        title: "Festivals & Muhurat",
        icon: Icons.festival_rounded,
        builder: (_) => const FestivalScreen(),
      ),
      _HomeMenuItem(
        title: "Donors of Mandir",
        icon: Icons.temple_hindu_rounded,
        builder: (_) => const DonorScreen(),
      ),
      _HomeMenuItem(
        title: "Profile Screen",
        icon: Icons.person_2_outlined,
        builder: (_) => const ProfileScreen(),
      ),
    ];

    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 20;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDeep,
      extendBodyBehindAppBar: true,
      appBar: PremiumGlassAppBar(title: "🔱|| આઈ શ્રી ખોડિયાર માઁ ||🚩"),
      body: GridView.builder(
        padding: EdgeInsets.only(
          top: topPadding,
          left: 16,
          right: 16,
          bottom: 24,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return _PremiumMenuCard(
            title: item.title,
            icon: item.icon,
            pageBuilder: item.builder,
            index: index,
          );
        },
      ),
    );
  }
}

class _PremiumMenuCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final WidgetBuilder pageBuilder;
  final int index;

  const _PremiumMenuCard({
    required this.title,
    required this.icon,
    required this.pageBuilder,
    required this.index,
  });

  @override
  State<_PremiumMenuCard> createState() => _PremiumMenuCardState();
}

class _PremiumMenuCardState extends State<_PremiumMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _scaleController.forward();
  void _onTapUp(TapUpDetails details) => _scaleController.reverse();
  void _onTapCancel() => _scaleController.reverse();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: widget.pageBuilder),
              );
            }
          });
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.surfaceLight, AppColors.scaffoldBackground],
              ),
              border: Border.all(
                color: AppColors.glassBorder.withOpacity(0.08),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primaryOrange.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 36,
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeMenuItem {
  const _HomeMenuItem({
    required this.title,
    required this.icon,
    required this.builder,
  });

  final String title;
  final IconData icon;
  final WidgetBuilder builder;
}
