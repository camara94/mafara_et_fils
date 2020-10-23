import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/login/login.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
import 'package:mafara_et_fils/model/panier.dart';
import 'package:mafara_et_fils/model/produit.dart';
import 'package:mafara_et_fils/shared/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailProduit extends StatefulWidget {
  final Produit prod;
  final Utilisateur utilisateur;
  DetailProduit({this.prod, this.utilisateur});
  

  @override
  _DetailProduitState createState() => _DetailProduitState( prod: this.prod, utilisateur: this.utilisateur);
}

class _DetailProduitState extends State<DetailProduit> {
  Paniers panier;
  final dynamic prod;
  Utilisateur utilisateur;
  String _selectedLocation;
  _DetailProduitState({this.prod, this.utilisateur});

  @override
  Widget build(BuildContext context) {
    double val =  double.parse(widget.prod.prix);
    double oldprice = val + val/10;
    List<String> _locations = [];
    setState(() {
      for(int i=1; i <= int.parse(this.prod.quantite); i++) {
        _locations.add( i.toString() );
      }
    });
    return  Scaffold(
         appBar: AppBar(
           title: Text(widget.prod.nom), 
           backgroundColor: drawerBackgroundColor,
           actions: [
           RaisedButton(
          color: drawerBackgroundColor,
          onPressed: ()  { Navigator.of(context).push(MaterialPageRoute(builder: (context)=> utilisateur != null? Panier(utilisateur: utilisateur,): LoginPage())); }, 
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 30,),
            ],
          ),
          ) 
         
        ],
           ),
         body: (widget.prod != null || widget.utilisateur != null)? ListView(
           children: [
             SingleChildScrollView(
               scrollDirection: Axis.vertical,
               
               child: Container(
                 height: MediaQuery.of(context).size.height/2,
                 color: Colors.black,
                child: GridTile(
                child: Container(
                  color: Colors.white,
                  child:(widget.prod.image != null && widget.prod.image != '')? Image.network('http://etablissementmanfaraetfils.com/${widget.prod.image}', fit: BoxFit.fill): Loading(),
                ),
                footer: ListTile(
                 leading: Text(widget.prod.nom, style: TextStyle(fontWeight: FontWeight.bold),),
                 title: Row(
                   children: [
                     Expanded(
                       child: Text('${double.parse(widget.prod.prix) + double.parse(widget.prod.prix)/10} GNF', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800, decoration: TextDecoration.lineThrough) )
                       ),
                       Expanded(
                       child: Text('${widget.prod.prix} GNF', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800) )
                       ),                       
                   ],
                 ),
                ),
               )
            ),
             ),
             Row(
               children: [
                 Expanded(
                   child: MaterialButton(
                     elevation: 0.5,
                     onPressed: (){
                       showDialog(context: context, builder:( context){
                         return new AlertDialog(
                           title: Text('Combiem de ${widget.prod.nom} Voulez-vous?'),
                           content: Row(
                             children: [
                                Text('Chosissez le nombre total: '),
                                 new DropdownButton( 
                                 value: _selectedLocation, 
                                 onChanged: (String newValue) { 
                                    setState(() { 
                                      _selectedLocation = newValue; 
                                      
                                    });  
                                  }, 
                                  items: _locations.map((String location) { return new DropdownMenuItem<String>( child: new Text('${location}', style: TextStyle(fontWeight: FontWeight.bold),), onTap: () {
                                     setState(() { 
                                      _selectedLocation = location; 
                                      panier = new Paniers(idClient: int.parse(utilisateur.id), idProduit: int.parse(prod.id), quantite: int.parse(location)  );
                                    });  
                                  }, ); 
                                 
                              }).toList()),
                             ],
                           ),
                           
                           actions: [
                             Expanded(
                              child: MaterialButton(
                                elevation: 0.5,
                                onPressed: (){
                                    if (utilisateur != null)
                                 {
                                     print('La quantite: ${panier.quantite}, id_client: ${panier.idClient}, id_prod: ${panier.idProduit}');
                                  setState(() {
                                     _addPanier(panier);
                                  });
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Panier(utilisateur: utilisateur,)));
                                 } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
                                 }
                                },
                                color: drawerBackgroundColor,
                                textColor: Colors.white,
                                child: Text('Ajouter au Panier'),
                              ),
                              ),
                             
                             MaterialButton(
                               onPressed: (){
                                 Navigator.of(context).pop(context);
                               }, 
                                child: Text('Fermer'),
                               ),
                           ],
                         );
                       });
                     },
                     color: Colors.white,
                     textColor: Colors.grey,
                     child: Row(
                       children: [
                         Expanded(
                           child: Row(
                             children: [
                               Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, color: drawerBackgroundColor, fontSize: 19.0),),
                             Icon(Icons.arrow_drop_down_circle)
                             ],
                           )
                           ),
                          
                       ],
                     ),
                   )
                   ),
                  Expanded(
                   child: MaterialButton(
                     elevation: 0.5,
                     onPressed: (){
                       showDialog(context: context, builder:( context){
                         return new AlertDialog(
                           title: Text('Quelle couleur de ${widget.prod.nom} Voulez-vous?'),
                           content: Text('Chosissez la couleur apropriée:'),
                           actions: [
                             MaterialButton(
                               onPressed: (){
                                 Navigator.of(context).pop(context);
                               }, 
                                child: Text('Fermer'),
                               ),
                              
                           ],
                         );
                       });
                     },
                     color: Colors.white,
                     textColor: Colors.grey,
                     child: Row(
                       children: [
                         Expanded(
                           child: Text('Couleur')
                           ),
                       ],
                     ),
                   )
                   )


               ],
             ),

             Row(
               children: [
                 Expanded(
                   child: MaterialButton(
                     elevation: 0.5,
                     onPressed: (){
                          showDialog(context: context, builder:( context){
                         return new AlertDialog(
                           title: Text('Combiem de ${widget.prod.nom} Voulez-vous?'),
                           content: Row(
                             children: [
                                Text('Chosissez le nombre total: '),
                                 new DropdownButton( 
                                 value: _selectedLocation, 
                                 onChanged: (String newValue) { 
                                    setState(() { 
                                      _selectedLocation = newValue; 
                                      
                                    });  
                                  }, 
                                  items: _locations.map((String location) { return new DropdownMenuItem<String>( child: new Text('${location}', style: TextStyle(fontWeight: FontWeight.bold),), onTap: () {
                                     setState(() { 
                                      _selectedLocation = location; 
                                      panier = new Paniers(idClient: int.parse(utilisateur.id), idProduit: int.parse(prod.id), quantite: int.parse(location)  );
                                    });  
                                  }, ); 
                                 
                              }).toList()),
                             ],
                           ),
                           
                           actions: [
                             Expanded(
                              child: MaterialButton(
                                elevation: 0.5,
                                onPressed: (){
                                  if (utilisateur != null)
                                 {
                                     print('La quantite: ${panier.quantite}, id_client: ${panier.idClient}, id_prod: ${panier.idProduit}');
                                  setState(() {
                                     _addPanier(panier);
                                  });
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Panier(utilisateur: utilisateur,)));
                                 } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
                                 }
                                
                                },
                                color: drawerBackgroundColor,
                                textColor: Colors.white,
                                child: Text('Ajouter au Panier'),
                              ),
                              ),
                             
                             MaterialButton(
                               onPressed: (){
                                 Navigator.of(context).pop(context);
                               }, 
                                child: Text('Fermer'),
                               ),
                           ],
                         );
                       });
                     },
                     color: drawerBackgroundColor,
                     textColor: Colors.white,
                     child: Text('Ajouter à votre panier'),
                   ),
                   ),
                  IconButton( icon: Icon(Icons.add_shopping_cart, color:drawerBackgroundColor,), onPressed: (){}),
                  IconButton( icon: Icon(Icons.favorite_border, color: drawerBackgroundColor,), onPressed: (){}),
                        
               ],
              
             ),
             Divider(),
             ListTile(
               title: Text('Le détail de ${widget.prod.nom}', style: TextStyle(fontWeight: FontWeight.bold),),
               subtitle: Text('Description: ${widget.prod.description}'),
             ),
            Divider(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: Text('Nom: ${widget.prod.nom}',  style: TextStyle(color: Colors.green),),
                ),

              ],
            ),
            Divider(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Condition d\'utilisation: ',  style: TextStyle(color: Colors.green),),
                ),

              ],
            )
           ],
         ): Loading(),
       );
  }

  
  void _addPanier(Paniers panier) async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/postPanier.php?idClient=${panier.idClient}&idProduit=${panier.idProduit}&quantite=${panier.quantite}';
    var response = await http.get(url);
     print('Autre Response status: ${response.statusCode}');
     print('Autre Response body: ${jsonDecode(response.body)[0].length}');
     
  }
}