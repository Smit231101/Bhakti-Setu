import 'package:bhakti_setu/data/models/event_model.dart';
import 'package:bhakti_setu/data/repositories/event_repository.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository repository;

  EventProvider(this.repository);

  List<EventModel> events = [];
  bool isLoading = false;
  String? error;

  Future<void> loadEvents() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      events = await repository.fetchEvents();
      print("Events loaded: ${events.length}");
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
