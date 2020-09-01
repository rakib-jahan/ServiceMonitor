import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_monitor/service.model.dart';

class FirestoreService {
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('services');

  List<Service> getServicesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Service.fromMap(doc.data(), doc.id);
    }).toList();
  }

  Stream<List<Service>> getServices() {
    return _collectionReference.snapshots().map(getServicesFromSnapshot);
  }

  List<ServiceLogDetails> getServiceLogDetailsFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ServiceLogDetails.fromMap(doc.data());
    }).toList();
  }

  Stream<List<ServiceLogDetails>> getServiceLogDetails(String id) {
    return _collectionReference
        .doc(id)
        .collection('all-log')
        .snapshots()
        .map(getServiceLogDetailsFromSnapshot);
  }
}
