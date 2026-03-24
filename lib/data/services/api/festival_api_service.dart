import 'package:bhakti_setu/core/constants/api_constants.dart';
import 'package:bhakti_setu/data/models/festival_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FestivalApiService {
  final Dio _dio = Dio();
  Future<List<FestivalModel>> fetchFestivals(String year) async {
    try {
      final url = "${ApiConstants.baseUrl}/$year.json";
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Festivals loading...");
        }
        final List<dynamic> data = response.data;
        return data
            .map((e) => FestivalModel.fromJson(e))
            .where((f) => f.type == "Religional Festival")
            .toList();
      } else {
        if (kDebugMode) {
          print("Failed to load festival");
        }
        throw Exception("Failed to load festival");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      throw Exception("API Error: $e");
    }
  }
}
