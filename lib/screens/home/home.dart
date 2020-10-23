import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/component/horizontal_list_view.dart';
import 'package:mafara_et_fils/screens/component/produit_view.dart';
import 'package:mafara_et_fils/screens/menu/collapsing_navigation_drawer_widget.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/login/login.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
import 'package:mafara_et_fils/screens/pages/search_produit.dart';
import 'package:mafara_et_fils/services/database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mafara_et_fils/shared/loading.dart';



class Home extends StatefulWidget {
  Utilisateur utilisateur;
  Home({this.utilisateur});

  @override
  _HomeState createState() => _HomeState(utilisateur: this.utilisateur);
}

class _HomeState extends State<Home> {
  Utilisateur utilisateur;
  _HomeState({this.utilisateur});
  List<Categories> categories = [];
  final DatabaseService _db = DatabaseService();
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  var pageIndex = 0;
 static  List<String> images;
  List<dynamic> sliders;
  List<Figure> listImages = [];

  void initState() {
    super.initState();
    _getSliders();
  }

 
  @override
  Widget build(BuildContext context) {
    //final sliders = _db.getSliderData() as List<Sliders>;

    return Scaffold(
      appBar: AppBar(
           title: Text('Accueil'), 
           backgroundColor: drawerBackgroundColor,
           actions: [
          RaisedButton(
          color: drawerBackgroundColor,
          onPressed: ()  { 
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SearchProduit()  ));
             }, 
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white, size: 30,),
            ],
          ),
          ) ,
           RaisedButton(
          color: drawerBackgroundColor,
          onPressed: ()  { Navigator.of(context).push(MaterialPageRoute(builder: (context)=> utilisateur != null ? Panier(utilisateur: utilisateur,): LoginPage())); }, 
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 30,),
            ],
          ),
          ) ,
         
        ],
           ),
      drawer: CollapsingNavigationDrawer(utilisateur: utilisateur,), 
      body: ListView(
        children: [
          //mon carousel
          
          new Container(
            height: MediaQuery.of(context).size.height/5,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(0.0),
            child: listImages.length > 0? CarouselSlider.builder(
              height: 400.0,
              initialPage:
              0, //allows you to set the first item to be displayed
              scrollDirection: Axis.horizontal, //can be set to Axis.vertical
              pauseAutoPlayOnTouch: Duration(
              seconds: 5), //it pauses the sliding if carousel is touched,
              onPageChanged: (int pageNumber) {
              //this triggers everytime a slide changes
              },
              viewportFraction: 0.99,
              enlargeCenterPage: true, //is false by default
              aspectRatio: 16/8,
              autoPlay: true ,
              itemCount: listImages.length, 
              itemBuilder: (context, index) {
                return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.network(
                'https://etablissementmanfaraetfils.com/${listImages[index].image}',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                ),
                
                );
              }
              ): Loading(),
             /*new Carousel(
              boxFit: BoxFit.cover,
              images: ListView.builder(
                itemBuilder: (context, index)){

              },
              autoplay: true,
              dotBgColor: Colors.transparent,
              animationCurve: Curves.fastLinearToSlowEaseIn,
              animationDuration:  Duration(milliseconds: 1000),
            ),*/
          ),

          
          //Le padding avec le titre
          Container(
            color: drawerBackgroundColor,
            child: Padding(padding: const EdgeInsets.all(5.0), child: Text('Categories', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),),)
            ), 

          //ListView Horizontal
          HorizontalList(),

           //Le padding avec le titre
          Container(
            color: drawerBackgroundColor,
            child: Padding(padding: const EdgeInsets.all(5.0), child: Text('Les Produit disponibles', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),),)
            ), 
          
          //GridView
          Container(
            height: MediaQuery.of(context).size.height,
            child: ProduitView( utilisateur: this.utilisateur, axisCount: 2,),
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

  void _getSliders() async {
    var url = 'https://etablissementmanfaraetfils.com/apimanfara/getSlider.php';
    var response = await http.get(url);
    setState(() {    
      print('Autre Response status: ${response.statusCode}');
      print('Autre Response body: ${jsonDecode(response.body)[0].length}');
      for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
        listImages.add(
          new Figure(
            nom: jsonDecode(response.body)[0][i]['nom'],
            image: jsonDecode(response.body)[0][i]['image']
          )
          );
    }
   
     });
      setState(() { });
  }

}

class Figure {
  final String nom;
  final String image;
  Figure({this.nom, this.image});
}