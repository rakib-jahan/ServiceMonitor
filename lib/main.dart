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
        serviceName: 'Service 1',
        lastUpdate: '12-Aug-2020 11 AM',
        failedCount: 7,
        successCount: 17),
    Service(
        serviceName: 'Service 2',
        lastUpdate: '12-Aug-2020 11 AM',
        failedCount: 7,
        successCount: 17),
    Service(
        serviceName: 'Service 3',
        lastUpdate: '12-Aug-2020 11 AM',
        failedCount: 7,
        successCount: 17),
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
