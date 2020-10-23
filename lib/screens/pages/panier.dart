import 'package:flutter/material.dart';
import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/model/panier.dart';
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/cart_produit.dart';
import 'package:http/http.dart'  as http;
import 'dart:convert';

import 'package:mafara_et_fils/shared/loading.dart';

class Panier extends StatefulWidget {
  Utilisateur utilisateur;
  Panier({this.utilisateur});

  @override
  _PanierState createState() => _PanierState(utilisateur: utilisateur);
}

class _PanierState extends State<Panier> {
  Utilisateur utilisateur;
  List<Paniers> paniers = [];
  List<Produit> produits = [];
  _PanierState({this.utilisateur});

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(utilisateur != null)
    _getPaniers(int.parse(utilisateur.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: ( utilisateur != null  )? AppBar(
           title: Text('Panier'), 
           backgroundColor: drawerBackgroundColor,
           actions: [
           RaisedButton(
          color: drawerBackgroundColor,
          onPressed: () async {}, 
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white, size: 30,),
            ],
          ),
          ) 
         
        ],
           ): null,
           body: ( widget.utilisateur != null  )? CardProduit(
             utilisateur: utilisateur,
           ): MyApp(utilisateur: utilisateur,),
          /* bottomNavigationBar: new Container(
             color: Colors.white,
             child: Row(
               children: [
                 Expanded(
                   child: ListTile(
                     title: Text('Montant: '),
                     subtitle:  Text('${3000} GNF'),
                   )
                   ),
                   Expanded(
                     child: MaterialButton(
                       onPressed: (){},
                       child: Text('Vérifier votre panier', style: TextStyle(color: Colors.white),),
                       color: drawerBackgroundColor,
                       )
                     )
               ],
             ),
           ),*/
         
         );
  }

  void _getPaniers(int id) async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/getPanier.php?id=${id}';
    var response = await http.get(url);
     print('Autre Response status: ${response.statusCode}');
     print('Autre Response body: ${jsonDecode(response.body)[0].length}');
    setState(() {      
      for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
        paniers.add(new Paniers(
            id:int.parse(jsonDecode(response.body)[0][i]['id']), 
            idClient: int.parse(jsonDecode(response.body)[0][i]['idClient']), 
            idProduit: int.parse(jsonDecode(response.body)[0][i]['idProduit']),
            quantite: int.parse(jsonDecode(response.body)[0][i]['quantite']),
          ));
    }
   });
   paniers.forEach((element) { _getProduits(element.idProduit); });
   setState(() { });
  }

  void _getProduits(int id) async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/get.php?id=${id}';
    var response = await http.get(url);
     print('Autre Response status: ${response.statusCode}');
     print('Autre Response body: ${jsonDecode(response.body)[0].length}');
    setState(() {      
      for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
        produits.add(new Produit(
            id:jsonDecode(response.body)[0][i]['id'], 
            nom: jsonDecode(response.body)[0][i]['nom'], 
            description: jsonDecode(response.body)[0][i]['description'],
            designation: jsonDecode(response.body)[0][i]['designation'],
            disponible: jsonDecode(response.body)[0][i]['disponible'],
            image: jsonDecode(response.body)[0][i]['image'],
            prix: jsonDecode(response.body)[0][i]['prix'],
            quantite: jsonDecode(response.body)[0][i]['quantite']
          ));
    }
    print('dans la page card produit: ${produits}');
   });
      setState(() { });
  }
}