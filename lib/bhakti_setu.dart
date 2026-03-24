import 'package:bhakti_setu/data/repositories/festival_repository.dart';
import 'package:bhakti_setu/data/services/api/festival_api_service.dart';
import 'package:bhakti_setu/presentation/providers/festival_provider.dart';
import 'package:bhakti_setu/presentation/screens/festival/festival_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BhaktiSetuApp extends StatelessWidget {
  const BhaktiSetuApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              FestivalProvider(FestivalRepository(FestivalApiService())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Bhakti Setu App",
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black45,
        ),
        home: FestivalScreen(),
      ),
    );
  }
}
