import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Service {
  String serviceName;
  String lastUpdate;
  int successCount;
  int failedCount;
  double cpu;
  double ram;

  Service(
      {this.serviceName,
      this.lastUpdate,
      this.successCount,
      this.failedCount,
      this.cpu,
      this.ram});

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
      failedCount: map['failedCount'] == null ? 0 : map['failedCount'],
      cpu: map['cpu'] == null ? 0 : double.parse(map['cpu'].toString()),
      ram: map['ram'] == null ? 0 : double.parse(map['ram'].toString()),
    );
  }
}

class ServiceLogDetails {
  String createdDate;
  String failedDetails;
  double cpu;
  double disk;
  double memory;
  Status logType;
  ServiceLogDetails(
      {this.createdDate,
      this.failedDetails,
      this.cpu,
      this.memory,
      this.disk,
      this.logType});

  static ServiceLogDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    String createdDate;
    if (map['createdDate'] == null)
      createdDate = 'Service off';
    else {
      Timestamp t = map['createdDate'];
      DateTime d = t.toDate();
      createdDate = DateFormat.yMMMd().add_jm().format(d);
    }

    return ServiceLogDetails(
        createdDate: createdDate,
        failedDetails: map['failedDetails'] == null ? '' : map['failedDetails'],
        cpu: map['cpu'] == null ? 0 : double.parse(map['cpu'].toString()),
        memory:
            map['memory'] == null ? 0 : double.parse(map['memory'].toString()),
        disk: map['disk'] == null ? 0 : double.parse(map['disk'].toString()),
        logType: map['logType'] == null
            ? Status.none
            : Status.values[int.parse(map['logType'].toString())]);
  }
}

enum Status { none, success, failed, stopped }
