import 'dart:async';
import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/screens/authenticate/register.dart';
import 'package:mafara_et_fils/screens/home/home.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/wrapper.dart';

import 'package:mafara_et_fils/shared/loading.dart';
import 'package:mafara_et_fils/services/auth.dart';
import 'package:mafara_et_fils/services/database.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/shared/constants.dart';
import 'package:mafara_et_fils/shared/const.dart';
import 'package:mafara_et_fils/shared/constante.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SignInWithEmail extends StatefulWidget {
  final Function toogleView;
  String messageError;
  SignInWithEmail({ this.toogleView, this.messageError });

  @override
  _SignInWithEmailState createState() => _SignInWithEmailState(messageError: messageError);
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  String messageError;
  _SignInWithEmailState({this.messageError});
  ScrollController scrollController;
  final AuthService _auth = AuthService();
   DatabaseService _db = null;
   List<Utilisateur> utilisateurs;
  
  final _formKey = GlobalKey<FormState>();
  
  // text field state
  String email =  '';
  String password = '';
  String error =  '';
  bool loading = false;
  

  @override
  Widget build(BuildContext context) {

    return loading == false? Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric( vertical: 20.0, horizontal: 50.0 ) ,
            child: Form(
               key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecortion(),
                    validator: (val) => val.isEmpty ? 'Entrez votre émail valide ?': null,
                    obscureText: false,
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                   SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecortion(name: 'Votre mot de passe'),
                    validator: (val) => val.length < 3 ? 'Votre mot de passe doit depasser 8 caractères': null,
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });

                    },
                  ),
                  Text(messageError==null?'':messageError, style: TextStyle(color: Colors.red),),
                  SizedBox(height: 20.0),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                      RaisedButton(
                    color: Colors.pink[400],
                    child: Row(
                      children: [
                       Icon( Icons.person, color: Colors.white,)
                        ,
                        Text(
                      ' Se Connecter',
                       style: TextStyle(color: Colors.white),
                      ), 
                      ],
                    ),
                    onPressed: () async {
                        if ( _formKey.currentState.validate() ) {
                          print('Votre email: ${email} et votre password: ${password}');
                       setState(() {
                         loading = true;
                       });   
                          
                    var url = 'http://etablissementmanfaraetfils.com/apimanfara/getUser.php?email=${email}&password=${password}';
                          var response = await http.get(url);
                         print('Response status: ${response.statusCode}');
                          print('Response body: ${response.body}');
                          Utilisateur utilisateur;
                          if (jsonDecode(response.body).length > 0)
                          for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
                          utilisateur = new Utilisateur(
                              id:jsonDecode(response.body)[0][i]['id'], 
                              nom: jsonDecode(response.body)[0][i]['nom'], 
                              prenom: jsonDecode(response.body)[0][i]['prenom'],
                              email: jsonDecode(response.body)[0][i]['email'],
                              tel: jsonDecode(response.body)[0][i]['tel'],
                              role: jsonDecode(response.body)[0][i]['role'],
                              password: jsonDecode(response.body)[0][i]['password'],
                              username: jsonDecode(response.body)[0][i]['username']
                            ); 

                             
                          }

                        var  _timer = Timer(Duration(seconds: 5), () => setState(() {
                              messageError = 'Veuillez vérifier vos Identifiants';
                              loading = false;
                              Navigator.of(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(utilisateur: utilisateur, messageError: messageError,) )); 
                            }));

                          
                        

                         if( utilisateur != null)
                          {
                            setState(() {
                              
                            });
                          }
                         

              
                          
                            
                          }
                          
                        }
                     
                    ), 

                    RaisedButton(
                    color: drawerBackgroundColor,
                    child: Row(
                      children: [
                       Icon( Icons.group_add, color: Colors.white,)
                        ,
                        Text(
                      ' S\'enrégistrer',
                       style: TextStyle(color: Colors.white),
                      )
                      ],
                    ),
                    onPressed: () async {
                        
                            Navigator.of(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Register() ));
                          }                                    
                    ), 
                   ],
                 ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle( color: Colors.red, fontSize: 14.0 ),
                      )
                ],
                
              )
            ,
      ),
    )
    ): Loading(); 
  } 

   void onDrawerClick() {
    //if scrollcontroller.offset != 0.0 then we set to closed the drawer(with animation to offset zero position) if is not 1 then open the drawer
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        250,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }


  void _getUtilisateurs(String email, String password) async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/getUser.php?eamil=' + email + '&password='+password;
    var response = await http.get(url);
     print('Autre Response status: ${response.statusCode}');
     print('Autre Response body: ${jsonDecode(response.body)[0].length}');
    setState(() {      
      for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
        utilisateurs.add(new Utilisateur(
            id:jsonDecode(response.body)[0][i]['id'], 
            nom: jsonDecode(response.body)[0][i]['nom'], 
            prenom: jsonDecode(response.body)[0][i]['prenom'],
            email: jsonDecode(response.body)[0][i]['email'],
            tel: jsonDecode(response.body)[0][i]['tel'],
            role: jsonDecode(response.body)[0][i]['role'],
            password: jsonDecode(response.body)[0][i]['password'],
            username: jsonDecode(response.body)[0][i]['username']
          ));
    }
    print('les utilisateur: ${utilisateurs}');
   });
      setState(() { });
  }
}