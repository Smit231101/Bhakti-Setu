import 'package:bhakti_setu/data/models/festival_model.dart';
import 'package:bhakti_setu/data/services/api/festival_api_service.dart';

class FestivalRepository {
  final FestivalApiService apiService;

  FestivalRepository(this.apiService);

  Future<List<FestivalModel>> getFestivals(String year) async {
    return await apiService.fetchFestivals(year);
  }
}
