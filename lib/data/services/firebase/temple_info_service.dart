import 'package:cloud_firestore/cloud_firestore.dart';

class TempleInfoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getJayantiData() async {
    final doc = await _firestore
        .collection("temple_info")
        .doc("khodiyar_jayanti")
        .get();

    return doc.data() ?? {};
  }
}
