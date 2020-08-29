import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:service_monitor/service.model.dart';

class FirestoreService {
  // final CollectionReference _servicesCollectionReference =
  //     FirebaseFirestore.instance.collection('services');

  Stream<List<Service>> getServiceStream() async* {
    final CollectionReference _servicesCollectionReference =
        FirebaseFirestore.instance.collection('services');
    var servicesDocuments = await _servicesCollectionReference.get();
    if (servicesDocuments.docs.isNotEmpty) {
      servicesDocuments.docs.forEach((DocumentSnapshot doc) async {
        var servicesDetailDocuments = await _servicesCollectionReference
            .doc(doc.id)
            .collection("recent-log")
            .get();
        if (servicesDetailDocuments.docs.isNotEmpty) {
          return servicesDetailDocuments.docs
              .map((snapshot) => Service.fromMap(snapshot.data(), doc.id))
              .toList();
        }
      });
    }
  }

  Future getServices() async {
    try {
      final CollectionReference _servicesCollectionReference =
          FirebaseFirestore.instance.collection('services');
      var servicesDocuments = await _servicesCollectionReference.get();
      if (servicesDocuments.docs.isNotEmpty) {
        servicesDocuments.docs.forEach((DocumentSnapshot doc) async {
          var servicesDetailDocuments = await _servicesCollectionReference
              .doc(doc.id)
              .collection("recent-log")
              .get();

          if (servicesDetailDocuments.docs.isNotEmpty) {
            return servicesDetailDocuments.docs
                .map((snapshot) => Service.fromMap(snapshot.data(), doc.id))
                .toList();
          }
        });
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }
}
