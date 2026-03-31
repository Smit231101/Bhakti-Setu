import 'package:bhakti_setu/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({super.key});

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumGlassAppBar(title: "Donors of Mandir"),
    );
  }
}