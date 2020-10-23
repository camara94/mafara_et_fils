import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/user.dart';
import 'package:mafara_et_fils/screens/authenticate/signinwithemail.dart';
import 'package:mafara_et_fils/screens/menu/collapsing_navigation_drawer_widget.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:mafara_et_fils/services/auth.dart';
import 'package:mafara_et_fils/screens/menu/autre_menu.dart';

import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(
    MyApp()
  ) ;
}

class MyApp extends StatelessWidget {
  final Utilisateur utilisateur;
  String messageError;
  MyApp({this.utilisateur, this.messageError});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Etablissement Manfara & Fils',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: MyHomePage(utilisateur: this.utilisateur),
      );
  }
}

class MyHomePage extends StatefulWidget {
  final Utilisateur utilisateur;
  MyHomePage({this.utilisateur});
  String messageError;
  @override
  _MyHomePageState createState() => _MyHomePageState(utilisateur: this.utilisateur);
}

class _MyHomePageState extends State<MyHomePage> {
  Utilisateur utilisateur;
  List<dynamic> listUtilisateurs = [];
  List<Utilisateur> utilisateurs = [];
  final _auth = AuthService();
  _MyHomePageState({this.utilisateur});
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUtilisateurs();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text('Etes-vous sùr de vouloir quitter?'), actions: <Widget>[
                RaisedButton(
                    child: Text('Oui'),
                    onPressed: () => Navigator.of(context).pop(true)),
                RaisedButton(
                    child: Text('Annuler'),
                    onPressed: () => Navigator.of(context).pop(false)),
              ])),
        child: Scaffold(
        drawer: CollapsingNavigationDrawer(utilisateur: utilisateur,),  //AutreMenu(), //   
        body: Wrapper(utilisateur: this.utilisateur,)
        /*Stack(
          children: <Widget>[
            Container(color: selectedColor,),
            CollapsingNavigationDrawer()
          ],
        )*/
      ));
  }

  void  getUtilisteurFromFirebase()  {
      setState(() {  
          Firestore.instance.collection("utilisateurs").getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            listUtilisateurs.add(result.data);
          });
          setState(() { });
          //rint(listUtilisateurs);
          //listProduits.forEach((e) {print(e['nom']); });
          _getUtilisateurs();
      });
    }); 
  }


  void _getUtilisateurs() async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/getUser.php';
    var response = await http.get(url);
    setState(() {      
      print('Autre Response status: ${response.statusCode}');
      print('Autre Response body: ${jsonDecode(response.body)[0].length}');
      for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
        utilisateurs.add(new Utilisateur(
            id:jsonDecode(response.body)[0][i]['id'], 
            nom: jsonDecode(response.body)[0][i]['nom'], 
            prenom: jsonDecode(response.body)[0][i]['prenom'],
            email: jsonDecode(response.body)[0][i]['email'],
            tel: jsonDecode(response.body)[0][i]['tel'],
            role: jsonDecode(response.body)[0][i]['role'],
            password: jsonDecode(response.body)[0][i]['password'],
            username: jsonDecode(response.body)[0][i]['username']
          ));
    }
    print('les users: ${utilisateurs}');
     });
      setState(() { });
  }
}