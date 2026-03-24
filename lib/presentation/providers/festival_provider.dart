import 'package:flutter/material.dart';
import '../../data/models/festival_model.dart';
import '../../data/repositories/festival_repository.dart';

class FestivalProvider extends ChangeNotifier {
  final FestivalRepository repository;

  FestivalProvider(this.repository);

  List<FestivalModel> festivals = [];
  bool isLoading = false;
  String? error;

  Future<void> loadFestivals(String year) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      festivals = await repository.getFestivals(year);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
