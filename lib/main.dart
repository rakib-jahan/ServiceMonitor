import 'package:flutter/material.dart';
import 'package:service_monitor/service.card.dart';
import 'service.model.dart';

void main() {
  runApp(Dashboard());
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Service> services = [
    Service(
        id: 1,
        serviceName: 'Service 1',
        lastRun: '12-Aug-2020 11 AM',
        errorCount: 7,
        successCount: 17),
    Service(
        id: 2,
        serviceName: 'Service 2',
        lastRun: '12-Aug-2020 9 AM',
        errorCount: 88,
        successCount: 99),
    Service(
        id: 3,
        serviceName: 'Service 3',
        lastRun: '12-Aug-2020 10 PM',
        errorCount: 0,
        successCount: 11)
  ];

  @override
  Widget build(BuildContext context) {
    final title = 'Dashboard';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
        body: GridView.count(
          padding: EdgeInsets.all(5.0),
          crossAxisCount: 2,
          children: services
              .map(
                (service) => ServiceCard(service: service),
              )
              .toList(),
        ),
      ),
    );
  }
}
