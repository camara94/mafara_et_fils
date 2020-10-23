import 'package:flutter/material.dart';
import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/model/panier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/pages/simple_card.dart';
import 'package:mafara_et_fils/shared/loading.dart';

class CardProduit extends StatefulWidget {
  Utilisateur utilisateur;
  CardProduit({this.utilisateur});

  @override
  _CardProduitState createState() => _CardProduitState(utilisateur: utilisateur);
}

class _CardProduitState extends State<CardProduit> {
  Utilisateur utilisateur;
  List<Paniers> paniers = [];
  List<Produit> produits = [];
  _CardProduitState({this.utilisateur});


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPaniers(int.parse(utilisateur.id));
  }

  @override
  Widget build(BuildContext context) {
    
    produits.forEach((element) {
      print('dans le panier il ya: ${element.nom}');
    });
    return (widget.utilisateur != null)?  Container(
       child: ListView.builder(
         itemCount: produits.length,
         itemBuilder: (context, index) {
           return utilisateur != null? SimpleCard(utilisateur: utilisateur, produit: produits[index], qte:paniers[index].quantite): MyApp(utilisateur: utilisateur,);
         },
       ),
    ): MyApp( utilisateur: utilisateur, );
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
   setState(() {
    });
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