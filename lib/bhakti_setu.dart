import 'package:bhakti_setu/core/theme/app_colors.dart';
import 'package:bhakti_setu/presentation/app_providers.dart';
import 'package:bhakti_setu/presentation/screens/auth/auth_wrapper.dart';
import 'package:bhakti_setu/presentation/screens/splash%20screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BhaktiSetuApp extends StatelessWidget {
  const BhaktiSetuApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Bhakti Setu App",
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          primaryColor: AppColors.primaryOrange,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
