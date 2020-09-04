import 'dart:math';
import 'package:flutter/material.dart';
import 'package:service_monitor/card_message.dart';
import 'package:service_monitor/service.model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'firestore.service.dart';

class ServiceDetails extends StatefulWidget {
  final Service item;

  const ServiceDetails({Key key, this.item}) : super(key: key);

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  FirestoreService _service = FirestoreService();
  List<charts.Series> seriesList;

  static List<charts.Series<Sales, String>> _createRandomData() {
    final random = Random();
    final salesData = [
      Sales('2', random.nextInt(10)),
      Sales('4', random.nextInt(10)),
      Sales('6', random.nextInt(10)),
      Sales('8', random.nextInt(10)),
      Sales('10', random.nextInt(10)),
      Sales('12', random.nextInt(10)),
      Sales('14', random.nextInt(10)),
      Sales('16', random.nextInt(10)),
      Sales('18', random.nextInt(10)),
      Sales('20', random.nextInt(10)),
      Sales('22', random.nextInt(10)),
      Sales('0', random.nextInt(10))
    ];
    return [
      charts.Series<Sales, String>(
        id: 'Sales',
        domainFn: (Sales sales, _) => sales.year,
        measureFn: (Sales sales, _) => sales.sales,
        data: salesData,
        colorFn: (datum, index) =>
            charts.ColorUtil.fromDartColor(Colors.red[800]),
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createRandomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.item.serviceName),
        actions: [
          new IconButton(
              icon: Icon(
                Icons.insert_chart,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('7 days failed status graph'),
                      actions: [
                        Container(
                          height: 400,
                          width: 400,
                          padding: EdgeInsets.all(5),
                          child: charts.BarChart(
                            seriesList,
                            animate: true,
                            vertical: true,
                          ),
                        )
                      ],
                    );
                  }))
        ],
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
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                      color: Colors.green[500], size: 20),
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

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}
