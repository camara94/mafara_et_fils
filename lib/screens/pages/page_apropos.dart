import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/apropos.dart';
import 'package:mafara_et_fils/model/coordonneesSuplementaire.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
import 'package:mafara_et_fils/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_session/flutter_session.dart';

class PageApropos extends StatefulWidget {
  @override
  _PageAproposState createState() => _PageAproposState();
}

class _PageAproposState extends State<PageApropos> {
 
  String _phoneNumber;

  List<Apropos> apropos = [];

  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAproposFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    dynamic utilisateur = FlutterSession().get('utilisateur');
    return Scaffold(
       appBar: AppBar(
           title: Text('Apropos de nous'), 
           backgroundColor: drawerBackgroundColor,
           actions: [
           RaisedButton(
          color: drawerBackgroundColor,
          onPressed: ()  { Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Panier())); }, 
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 30,),
            ],
          ),
          ) ,
         
        ],
           ),
      //drawer: CollapsingNavigationDrawer(utilisateur: utilisateur,),
       body: apropos.length > 0? ListView(
         scrollDirection: Axis.vertical,
         children: [
            Image.network(apropos[0].image),

            Expanded(
              child: Text(''),
            ),
            Row(
              children: [
               Expanded(
                 flex: 4,        
                 child:  Container(
                    height: MediaQuery.of(context).size.height/30,
                    alignment: Alignment.center,
                    color: drawerBackgroundColor,
                    child: Text('Contactez-vous', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                 ),
              ],
            ),
             Card(
              elevation: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                     onPressed: () async { _launchURL('tel:${apropos[0].coordonneesSuplementaire.telephone}');  },
                    child: Icon(Icons.phone, size: 40.0,),
                  ),
                  MaterialButton(
                     onPressed: () async { _launchURL('mailto:${apropos[0].coordonneesSuplementaire.email}');  },
                    child: Icon(Icons.email, size: 40.0,),
                  ),
                   MaterialButton(
                    onPressed: () async { _launchURL(apropos[0].coordonneesSuplementaire.site);  },
                    child: Icon(Icons.language, size: 40.0,),
                  )
                ],
              )
            ),
            

            Expanded(
              child: Text(''),
            ),
            Row(
              children: [
               Expanded(
                 flex: 4,        
                 child:  Container(
                    height: MediaQuery.of(context).size.height/30,
                    alignment: Alignment.center,
                    color: drawerBackgroundColor,
                    child: Text('Présentation de l\'entreprise Manfara et fils', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                 ),
              ],
            ),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                   title: Text('Apropos'),
                   subtitle: Text(apropos[0].description, style: TextStyle(fontSize: 18.0),),
                 ),
                 ListTile(
                   title: Text('Produits et Services'),
                   subtitle: Text(apropos[0].produits, style: TextStyle(fontSize: 18.0),),
                 ),
                ],
              ) ,
            ),
            Expanded(
              child: Text(''),
            ),
            Row(
              children: [
               Expanded(
                 flex: 4,        
                 child:  Container(
                    height: MediaQuery.of(context).size.height/30,
                    alignment: Alignment.center,
                    color: drawerBackgroundColor,
                    child: Text('Coordonnées Suplementaires', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                 ),
              ],
            ),
             Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                   title: Text('Téléphone'),
                   subtitle: Text(apropos[0].coordonneesSuplementaire.telephone, style: TextStyle(fontSize: 18.0),),
                 ),
                  ListTile(
                   title: Text('Email'),
                   subtitle: Text(apropos[0].coordonneesSuplementaire.email, style: TextStyle(fontSize: 18.0),),
                 ),
                 ListTile(
                   title: Text('Site'),
                   subtitle: Text(apropos[0].coordonneesSuplementaire.site, style: TextStyle(fontSize: 18.0),),
                 )
                ],
              ) ,
            )
            
         ],
        ): Loading(),
    );
  }

  void getAproposFromFirebase()  {
      List<String> o = [];
      setState(() {  
          Firestore.instance.collection("apropos").getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            if(result.data != null)
              apropos.add(
                new Apropos(
                  adresse: result.data['adresse'],
                  contact: result.data['contact'],
                  coordonneesSuplementaire: CoordonneesSuplementaire(
                    email: result.data['coordonneesSuplementaire']['email'],
                    site: result.data['coordonneesSuplementaire']['site'],
                    telephone: result.data['coordonneesSuplementaire']['telephone']
                  ),
                  dateCreation: result.data['dateCreation'],
                  description: result.data['description'],
                  horaire: result.data['horaire'],
                  image: result.data['image'],
                  produits: result.data['produits']
                )
              );
              print(apropos);
          });
          setState(() {});
      });
    }); 

  }

  _launchURL(url) async {
    //const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<R> _accumulate<R>(Stream<R> input) {
    final items = <R>[];
    input.forEach((item) {
      if (item != null) {
        setState(() {
          items.add(item);
        });
      }
    });
    return items;
  }
}