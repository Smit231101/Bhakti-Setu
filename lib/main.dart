import 'package:bhakti_setu/views/dashboard_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BhaktiSetuApp());
}

class BhaktiSetuApp extends StatelessWidget {
  const BhaktiSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bhakti Setu App",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black45
      ),
      home: DashboardScreen(),
    );
  }
}