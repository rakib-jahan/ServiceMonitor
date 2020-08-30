import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      elevation: 0,
      child: Container(
        width: 200,
        height: 50,
        child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w800))),
      ),
    ));
  }
}
