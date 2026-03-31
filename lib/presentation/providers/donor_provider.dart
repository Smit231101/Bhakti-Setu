import 'package:bhakti_setu/data/models/donor_model.dart';
import 'package:bhakti_setu/data/repositories/donor_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DonorProvider extends ChangeNotifier {
  DonorRepository _repository;

  DonorProvider(this._repository);

  List<DonorModel> donors = [];
  bool isLoading = false;
  String? error;

  Future<void> loadDonors() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      donors = await _repository.fetchDonors();
      if (kDebugMode) {
        print("Donors: ${donors.length}");
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
