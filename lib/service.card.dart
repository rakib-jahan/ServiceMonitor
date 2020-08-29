import 'package:flutter/material.dart';
import 'package:service_monitor/service.details.dart';
import 'package:service_monitor/service.model.dart';

class ServiceCard extends StatefulWidget {
  final Service service;

  const ServiceCard({Key key, this.service}) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetails(
              item: widget.service,
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.service.serviceName,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.green,
                    fontWeight: FontWeight.w400)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.service.successCount.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
                Container(
                    height: 40, child: VerticalDivider(color: Colors.grey)),
                Text(widget.service.failedCount.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.red,
                        fontWeight: FontWeight.bold))
              ],
            ),
            Text(widget.service.lastUpdate,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
