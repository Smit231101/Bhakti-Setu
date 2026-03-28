import 'package:bhakti_setu/data/models/event_model.dart';
import 'package:bhakti_setu/data/services/firebase/firestore_service.dart';

class EventRepository {
  final EventFirestoreService service;

  EventRepository(this.service);

  Future<List<EventModel>> fetchEvents() async {
    return await service.getEvents();
  }
}
