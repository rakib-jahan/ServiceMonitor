import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_monitor/card_message.dart';
import 'package:service_monitor/service.model.dart';

import 'firestore.service.dart';

class ServiceDetails extends StatefulWidget {
  final Service item;

  const ServiceDetails({Key key, this.item}) : super(key: key);

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  FirestoreService _service = FirestoreService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.item.serviceName),
      ),
      body: Center(
        child: FutureBuilder(
          future: _service.getServiceLogs(widget.item.serviceName),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              String text = 'Loading ...';
              return CardMessage(text: text);
            } else if (!snapshot.hasData) {
              String text = 'No data ...';
              return CardMessage(text: text);
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot ds = snapshot.data[index];
                  ServiceLogDetails service =
                      ServiceLogDetails.fromMap(ds.data());
                  return Card(
                    child: ListTile(
                      leading: service.logType == Status.failed
                          ? Icon(
                              Icons.error,
                              color: Colors.red[800],
                              size: 45,
                            )
                          : Icon(Icons.check_circle,
                              color: Colors.teal, size: 45),
                      title: Text(service.createdDate),
                      subtitle: service.logType == Status.failed
                          ? Text(service.failedDetails)
                          : Text(''),
                      isThreeLine: true,
                      dense: true,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
