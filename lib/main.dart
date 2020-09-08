import 'package:flutter/material.dart';
import 'package:mafara_et_fils/screens/menu/collapsing_navigation_drawer_widget.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Etablissement Manfara & Fils',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: drawerBackgroundColor,
        title: Text("Etablissement Manfara & Fils",),
      ),
      drawer: CollapsingNavigationDrawer(),    
      body: Wrapper()
      /*Stack(
        children: <Widget>[
          Container(color: selectedColor,),
          CollapsingNavigationDrawer()
        ],
      )*/
    );
  }
}