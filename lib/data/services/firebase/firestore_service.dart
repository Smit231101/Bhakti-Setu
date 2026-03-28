import 'package:bhakti_setu/data/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<EventModel>> getEvents() async {
    final snapshot = await _firestore.collection("events").get();

    return snapshot.docs
        .map((doc) => EventModel.fromFirebase(doc.data()))
        .toList();
  }
}
