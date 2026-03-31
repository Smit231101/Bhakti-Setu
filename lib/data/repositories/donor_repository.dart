import 'package:bhakti_setu/data/models/donor_model.dart';
import 'package:bhakti_setu/data/services/firebase/firestore_service.dart';

class DonorRepository {
  final DonorFirestoreService _service;

  DonorRepository(this._service);

  Future<List<DonorModel>> fetchDonors() async {
    return await _service.getDonors();
  }
}
