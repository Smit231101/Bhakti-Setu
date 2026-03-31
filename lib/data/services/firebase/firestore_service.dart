import 'package:bhakti_setu/data/models/donor_model.dart';
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

class DonorFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DonorModel>> getDonors() async {
    final snapshot = await _firestore.collection("donors").get();

    return snapshot.docs
        .map((doc) => DonorModel.fromFirestore(doc.data()))
        .toList();
  }
}
