import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Service {
  String serviceName;
  String lastUpdate;
  int successCount;
  int failedCount;

  Service(
      {this.serviceName, this.lastUpdate, this.successCount, this.failedCount});

  static Service fromMap(Map<String, dynamic> map, String serviceName) {
    if (map == null) return null;

    Timestamp t = map['lastUpdate'];
    DateTime d = t.toDate();

    return Service(
        lastUpdate: DateFormat.yMMMd().add_jm().format(d),
        serviceName: serviceName,
        successCount: map['successCount'],
        failedCount: map['failedCount']);
  }
}
