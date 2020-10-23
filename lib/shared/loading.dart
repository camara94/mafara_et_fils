import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mafara_et_fils/screens/menu/custom_navigation_drawer.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: drawerBackgroundColor,
      child: SpinKitPouringHourglass(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}