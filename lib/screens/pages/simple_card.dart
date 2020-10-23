import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/panier.dart';
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/pages/cart_produit.dart';
import 'package:mafara_et_fils/screens/pages/message.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SimpleCard extends StatefulWidget {
  final Produit produit;
  final double total;
  final int qte;
  final Utilisateur utilisateur;
  const SimpleCard({this.utilisateur, this.produit, this.qte, this.total});
  
  

  @override
  _SimpleCardState createState() => _SimpleCardState(utilisateur: utilisateur);
}

class _SimpleCardState extends State<SimpleCard> {
  Utilisateur utilisateur;
  List<Paniers> paniers = [];
  List<Produit> produits = [];

  _SimpleCardState({this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(  
        leading: Image.network('http://etablissementmanfaraetfils.com/${widget.produit.image}', width: 100.0, ),
        title: Text(widget.produit.nom),
        subtitle: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Disponibilité:', style: TextStyle(fontWeight: FontWeight.bold),)
                  ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(widget.produit.disponible, style: TextStyle(color: Colors.red),),
                  ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                  child: Text('Quantité:', style: TextStyle(fontWeight: FontWeight.bold),)
                  ),
                 Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text('${widget.qte}', style: TextStyle(color: Colors.red),),
                ),
                
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text('${widget.produit.prix} GNF', 
              style: TextStyle(color: Colors.red, fontSize: 17.0, fontWeight: FontWeight.bold),),
            )
          ],
        ),
        trailing: Column(
          children: [
            Expanded(
              child: MaterialButton(
              elevation: 1,
              child: IconButton(icon: Icon(Icons.delete_forever, size: 50.0,), onPressed: () {}, color: Colors.red),
              onPressed: () {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text('Etes-vous sûr de bien vouloir supprimer le ${widget.produit.nom}', style: TextStyle(color: Colors.red),),
                    actions: [
                       MaterialButton(onPressed: (){
                         Paniers panier = new Paniers(idClient: int.parse(widget.utilisateur.id), idProduit: int.parse(widget.produit.id));
                          String message = "";
                          setState(() {
                             _supprimerPanier(panier);
                             message = "Le produit: ${widget.produit.nom} est supprimé dans votre panier";
                          });
                          
                           Navigator.of(context).push(MaterialPageRoute(builder:(context)=> Message(utilisateur: utilisateur, message: message)));

                       }, child: Text('Oui', style: TextStyle(color: Colors.green, fontSize: 20.0),)),
                       MaterialButton(onPressed: (){Navigator.of(context).pop(context);}, child: Text('Non', style: TextStyle(color: Colors.red, fontSize: 20.0),))
                    ],
                  );
                });
              }
              )
              )
          ],
        ),
      ),
    );
  }

  void _supprimerPanier(Paniers panier) async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/deletePanier.php?idClient=${panier.idClient}&idProduit=${panier.idProduit}';
    var response = await http.get(url);
     print('Autre Response status: ${response.statusCode}');
    // print('Autre Response body: ${jsonDecode(response.body)[0].length}');   
  }
}