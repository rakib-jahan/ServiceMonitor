import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:service_monitor/service.card.dart';
import 'service.model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

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
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('services').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                String text = 'Loading ...';
                return CardMessage(text: text);
              }
              if (!snapshot.hasData) {
                String text = 'No data ...';
                return CardMessage(text: text);
              }
              return GridView.builder(
                  padding: EdgeInsets.all(5.0),
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    Service service = Service.fromMap(ds.data(), ds.id);
                    return ServiceCard(service: service);
                  });
            }),
      ),
    );
  }
}

class CardMessage extends StatelessWidget {
  const CardMessage({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      child: Container(
        width: 200,
        height: 50,
        child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500))),
      ),
    ));
  }
}
