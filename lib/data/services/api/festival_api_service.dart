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
        final data = response.data;

        if (data is! Map<String, dynamic>) {
          throw Exception("Unexpected response format");
        }

        final yearData = data[year];
        if (yearData is! Map<String, dynamic>) {
          throw Exception("No festival data found for year $year");
        }

        final festivals = <FestivalModel>[];

        for (final monthEntry in yearData.entries) {
          final monthData = monthEntry.value;
          if (monthData is! Map<String, dynamic>) {
            continue;
          }

          for (final dayEntry in monthData.entries) {
            final festivalData = dayEntry.value;
            if (festivalData is! Map<String, dynamic>) {
              continue;
            }

            festivals.add(
              FestivalModel.fromJson({
                ...festivalData,
                'date': dayEntry.key,
              }),
            );
          }
        }

        return festivals
            .where((festival) => festival.type == "Religional Festival")
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
