import 'package:flutter/material.dart';
import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:provider/provider.dart';
import 'package:mafara_et_fils/screens/menu/collapsing_navigation_drawer_widget.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/shared/loading.dart';
import 'package:mafara_et_fils/screens/pages/detail_produit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ProduitView extends StatefulWidget {
  Utilisateur utilisateur;
  int axisCount;
  ProduitView({this.utilisateur, this.axisCount});
  
  @override
  _ProduitViewState createState() => _ProduitViewState(utilisateur: this.utilisateur, axisCount: this.axisCount);
}

class _ProduitViewState extends State<ProduitView> {
  List<Produit> listProduits = [];
  Utilisateur utilisateur;
  int axisCount;
  _ProduitViewState({this.utilisateur, this.axisCount});
  void initState() {
    super.initState();
    //getProduitFromFirebase();
    _getProduits(); 
  }

  Produit produit;
  @override
  Widget build(BuildContext context) {
   /* Firestore.instance.collection("produit").getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            print(result.data);
          });
       });*/
      
       //listProduits.forEach((e) {print('Voir: ${e.nom}'); });
      return GridView.builder(
        itemCount: listProduits.length,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount, crossAxisSpacing: 2, childAspectRatio:1.5 ), 
          itemBuilder: (context, index) {
              return  SimpleProduit(prod: listProduits[index], utilisateur: this.utilisateur,);
          }
       );
    }


 /* void  getProduitFromFirebase()  {
      setState(() {  
          Firestore.instance.collection("produit").getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            listProduits.add(result.data);
          });
          setState(() { });
          //listProduits.forEach((e) {print(e['nom']); });
      });
    }); 
  }*/

  void _getProduits() async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/get.php';
    var response = await http.get(url);
    setState(() {      
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonDecode(response.body)[0].length}');
      for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
        listProduits.add(new Produit(
            id:jsonDecode(response.body)[0][i]['id'], 
            description: jsonDecode(response.body)[0][i]['description'], 
            designation: jsonDecode(response.body)[0][i]['designation'],
            disponible: jsonDecode(response.body)[0][i]['disponible'],
            image: jsonDecode(response.body)[0][i]['image'],
            nom: jsonDecode(response.body)[0][i]['nom'],
            prix: jsonDecode(response.body)[0][i]['prix'],
            quantite: jsonDecode(response.body)[0][i]['quantite']
          ));
    }
    print(listProduits[0].nom);
     });
      setState(() { });
  }
}

class SimpleProduit extends StatelessWidget {
  final Produit prod;
  final Utilisateur utilisateur;
  const SimpleProduit({this.prod, this.utilisateur});

  @override
  Widget build(BuildContext context) {
    double val =  double.parse(prod.prix);
    double oldprice = val + val/10;
    return (prod != null )? Card(
      child: Hero(
        tag: prod.id,
        child: Material(
          child: InkWell( 
            onTap: () => {
              Navigator.of(context).push( MaterialPageRoute(builder: (context) => DetailProduit(prod: prod, utilisateur: this.utilisateur,)))
              //print('Le PRODUIT A AFFICHER: ${prod.nom} \n ${prod.image} \n ${prod.quantite} \n${prod.description}')
              },
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(prod.nom.length >= 22? prod.nom.substring(0, 22): prod.nom, style: TextStyle(fontWeight: FontWeight.bold),),
                  title: Text('${prod.prix} GNF', style: TextStyle(fontWeight: FontWeight.w800, color:drawerBackgroundColor ),
                  ),
                  subtitle: Text('${oldprice} GNF', style: TextStyle(fontWeight: FontWeight.w800, color:Colors.red, decoration: TextDecoration.lineThrough ),
                  ),
                ),
              ),
              child: prod.image != null? Image.network('http://etablissementmanfaraetfils.com/${prod.image}', fit: BoxFit.fill, 
              height: MediaQuery.of(context).size.height,): Loading(),
            ),
          )
        ),
      ),
    ): Loading();
  }
}