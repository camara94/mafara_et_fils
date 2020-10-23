import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/authenticate/signinwithemail.dart';
import 'package:mafara_et_fils/screens/component/horizontal_list_view.dart';
import 'package:mafara_et_fils/screens/component/produit_view.dart';
import 'package:mafara_et_fils/screens/menu/collapsing_navigation_drawer_widget.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
import 'package:mafara_et_fils/screens/pages/search_produit.dart';
import 'package:mafara_et_fils/services/database.dart';
import 'package:mafara_et_fils/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';


class ListeProduit extends StatefulWidget {
  Utilisateur utilisateur;
  ListeProduit({this.utilisateur});

  @override
  _ListeProduitState createState() => _ListeProduitState(utilisateur: this.utilisateur);
}

class _ListeProduitState extends State<ListeProduit> {
  Utilisateur utilisateur;
  _ListeProduitState({this.utilisateur});
  final DatabaseService _db = DatabaseService();
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  var pageIndex = 0;
 static  List<String> images;
  List<dynamic> sliders;

  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final sliders = _db.getSliderData() as List<Sliders>;

    return Scaffold(
      appBar: AppBar(
           title: Text('Les Produits disponibles'), 
           backgroundColor: drawerBackgroundColor,
           actions: [
           RaisedButton(
          color: drawerBackgroundColor,
          onPressed: ()  {
              Navigator.of(context).pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchProduit()));
            }, 
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white, size: 30,),
            ],
          ),
          ) , 
          RaisedButton(
          color: drawerBackgroundColor,
          onPressed: ()  { Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Panier(utilisateur: utilisateur,))); }, 
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 30,),
            ],
          ),
          ) , 
         
        ],
           ),
      //drawer: CollapsingNavigationDrawer(utilisateur: utilisateur,), 
      body: ListView(
        children: [
          //GridView
          Container(
            height: MediaQuery.of(context).size.height,
            child: ProduitView( utilisateur: this.utilisateur, axisCount: 1,),
          ),
        ],
      ),
    );
  }
  
  Future<Produit> getSliderFromFirebase()  {
      List<String> o = [];
      setState(() {  
          Firestore.instance.collection("slider").getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            if(result.data != null)
              images.add(result.data['image']);
              print(result.data);
          });
          setState(() { sliders = sliders;});
      });
    }); 

  }
  
}