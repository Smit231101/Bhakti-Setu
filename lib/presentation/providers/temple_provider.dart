import 'package:bhakti_setu/data/services/firebase/temple_info_service.dart';
import 'package:flutter/material.dart';

class TempleProvider extends ChangeNotifier {
  final TempleInfoService _service;
  TempleProvider(this._service);

  String? jayantiDate;
  int displayYear = DateTime.now().year;

  Future<void> loadJayanti() async {
    final docData = await _service.getJayantiData();
    final datesMap = docData["dates"] as Map<String, dynamic>? ?? {};

    final now = DateTime.now();
    final currentYear = now.year;

    final currentYearDateStr = datesMap[currentYear.toString()];

    if (currentYearDateStr != null) {
      try {
        final parsedDate = DateTime.parse(currentYearDateStr);
        final today = DateTime(now.year, now.month, now.day);
        final jayantiDay = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
        );

        if (jayantiDay.isBefore(today)) {
          displayYear = currentYear + 1;
        } else {
          displayYear = currentYear;
        }
      } catch (e) {
        debugPrint("Error parsing date: $e");
        displayYear = currentYear;
      }
    } else {
      displayYear = currentYear + 1;
    }

    jayantiDate = datesMap[displayYear.toString()];
    notifyListeners();
  }
}
