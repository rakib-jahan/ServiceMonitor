import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getServiceLogs(String id) async {
    Query query =
        _firestore.collection('services').doc(id).collection('all-log');
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs;
  }
}
