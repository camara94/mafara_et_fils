import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/menu/collapsing_navigation_drawer_widget.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/detail_produit.dart';
import 'package:mafara_et_fils/screens/pages/login/login.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class SearchProduit extends StatefulWidget {
  Utilisateur utilisateur;
  SearchProduit({this.utilisateur});

  @override
  _SearchProduitState createState() => _SearchProduitState();
}

class _SearchProduitState extends State<SearchProduit> {
  List<Produit> produits = [];
  List<Produit> searchProduits = [];
  Future<List<Produit>> search(String search) async {
  await Future.delayed(Duration(seconds: 2));
  setState(() {
    _getProduits(search);
  });
  return produits;
}

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
           title: Text('Rechercher un produit'), 
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
          onPressed: ()  { Navigator.of(context).push(MaterialPageRoute(builder: (context)=> widget.utilisateur != null ? Panier(utilisateur: widget.utilisateur,): LoginPage())); }, 
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 30,),
            ],
          ),
          ) ,
         
        ],
           ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Produit>(
            onCancelled: (){
              Navigator.of(context).pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchProduit()));
            },
            textStyle: TextStyle(color: Colors.black),
            //placeHolder: Text('Entrez le noom du produit'),
            hintText: 'Entrez le nom du produit',
            onSearch: search,
            onItemFound: (Produit prod, int index) {
              return ListTile(
                leading: Image.network('http://etablissementmanfaraetfils.com/${prod.image}'),
                title: Text(prod.nom),
                subtitle: Text(prod.description),  
                onTap:(){
                  Navigator.of(context).pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailProduit(prod: prod,)));
                },    
              );
            },
          ),
        ),
      ),
    );
  }

  void _getProduits(String search) async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/searchProduit.php?nom=${search}';
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

  void _getProduit(String search) async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/get.php';
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

      this.produits.forEach((element) { 
          if (element.nom.toLowerCase().indexOf(search.toLowerCase()) > 0) 
          { 
            this.searchProduits.add(element);  
          }
          });
   });
      setState(() {
        
       });
  }
}
