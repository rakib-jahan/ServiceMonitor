import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_monitor/card_message.dart';
import 'package:service_monitor/service.model.dart';

class ServiceDetails extends StatefulWidget {
  final Service item;

  const ServiceDetails({Key key, this.item}) : super(key: key);

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getServiceDetails() async {
    Query query = _firestore
        .collection('services')
        .doc(widget.item.serviceName)
        .collection('all-log');
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    getServiceDetails();
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
          future: getServiceDetails(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              String text = 'Loading ...';
              return CardMessage(text: text);
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot ds = snapshot.data[index];
                  ServiceLogDetails service =
                      ServiceLogDetails.fromMap(ds.data());
                  return ListTile(title: Text(service.logType.toString()));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
