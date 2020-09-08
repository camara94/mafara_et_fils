import 'package:flutter/material.dart';

class Autheticate extends StatefulWidget {
  Autheticate({Key key}) : super(key: key);

  @override
  _AutheticateState createState() => _AutheticateState();
}

class _AutheticateState extends State<Autheticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('Authenticate'),
    );
  }
}