import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/cart_produit.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
class Message extends StatefulWidget {
  Utilisateur utilisateur;
  String message;
  Message({this.utilisateur, this.message});

  @override
  _MessageState createState() => _MessageState(utilisateur: utilisateur, message: message);
  
}

class _MessageState extends State<Message> {
  Utilisateur utilisateur;
  String message;
  _MessageState({this.utilisateur, this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
           title: Text('Suppression d\'un produit dans le panier'), 
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
           ),
       body: Card(
      child: ListTile(  
        title: Text(message),
        trailing: Column(
          children: [
            Expanded(
              child: MaterialButton(
               onPressed:(){ Navigator.of(context).push(MaterialPageRoute(builder:(context)=> Panier(utilisateur: utilisateur)));  },
              child: Expanded(
                child: Column(
                  children: [
                    Icon(Icons.shopping_cart),
                    Text(' Retour au panier', style: TextStyle( fontWeight: FontWeight.bold), ),
                  ],
                )
                )
             ) ,
              )
          ],
        ),
      ),
    )



    );
  }
}