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
    String lastUpdate;
    if (map['lastUpdate'] == null)
      lastUpdate = 'Service off';
    else {
      Timestamp t = map['lastUpdate'];
      DateTime d = t.toDate();
      lastUpdate = DateFormat.yMMMd().add_jm().format(d);
    }

    return Service(
        lastUpdate: lastUpdate,
        serviceName: serviceName,
        successCount: map['successCount'] == null ? 0 : map['successCount'],
        failedCount: map['failedCount'] == null ? 0 : map['failedCount']);
  }
}
