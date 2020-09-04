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
        child: StreamBuilder<List<ServiceLogDetails>>(
          stream: _service.getServiceLogDetails(widget.item.serviceName),
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
                  ServiceLogDetails service = snapshot.data[index];
                  int memory = service.memory == 0
                      ? 0
                      : ((service.memory * 100) / widget.item.ram).ceil();
                  int cpu = service.cpu == 0
                      ? 0
                      : ((service.cpu * 100) / widget.item.cpu).ceil();

                  return Card(
                    margin: EdgeInsets.all(5),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Text(service.createdDate,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 5),
                              Text(service.failedDetails,
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.memory, color: Colors.green[500]),
                                  SizedBox(width: 2),
                                  Text('$cpu %',
                                      style: TextStyle(color: Colors.grey)),
                                  SizedBox(width: 15),
                                  Icon(Icons.sim_card,
                                      color: Colors.green[500]),
                                  SizedBox(width: 2),
                                  Text('$memory %',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                          Spacer(),
                          service.logType == Status.failed
                              ? Icon(
                                  Icons.error,
                                  color: Colors.red[800],
                                  size: 40,
                                )
                              : Icon(Icons.check_circle,
                                  color: Colors.teal, size: 40),
                        ],
                      ),
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
