import 'package:flutter/material.dart';
import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/screens/authenticate/signinwithemail.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/services/auth.dart';
import 'package:mafara_et_fils/shared/constante.dart';
import 'package:mafara_et_fils/shared/loading.dart';
import 'package:mafara_et_fils/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toogleView;

  Register({ this.toogleView });


  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

   final AuthService _auth = AuthService();
   final _formKey = GlobalKey<FormState>();
   bool loading = false;
  
  // text field state
    String nom = '';
    String prenom = '';
    String cin = ''; 
    String telephone = '';
    String departement = '';
    String niveau = '';
    String role = 'etudiant';
    String email = '';
    String password = '';
    String error =  '';
    String confirm = '';
  @override
  Widget build(BuildContext context) {
    return loading == false? Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: drawerBackgroundColor,
          elevation: 0.0,
          title: Text("S'enregistrer  à Manfara et Fils"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text('Se Connecter', style: TextStyle(color: Colors.white),),
              onPressed: () { 
                 Navigator.of(context);
                 Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp() ));
               }
            )]
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric( vertical: 20.0, horizontal: 50.0 ) ,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecortion(name: 'Entrez votre nom'),
                    validator: (val) => val.isEmpty ? 'Le nom est requis': null,
                    obscureText: false,
                    onChanged: (val){
                      setState(() {
                        nom = val;
                      });
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecortion(name: 'Entrez votre prénom'),
                    validator: (val) => val.isEmpty ? 'Le prénom est requis': null,
                    obscureText: false,
                    onChanged: (val){
                      setState(() {
                        prenom = val;
                      });
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecortion(name: 'Entrez votre tétéphone'),
                    validator: (val) => val.isEmpty ? 'Le numero de tétéphone est requis': null,
                    obscureText: false,
                    onChanged: (val){
                      setState(() {
                        telephone = val;
                      });
                    },
                  ),
                 
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecortion(),
                    validator: (val) => val.isEmpty ? 'Entrez votre émail': null,
                    obscureText: false,
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecortion(name: 'Votre mot de passe'),
                    validator: (val) => val.length < 6 ? 'Votre mot de passe doit depasser 6 caractères': null,
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        password = val;
                        confirm = val;
                      });
                    },
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecortion(name: 'Confirmation'),
                    validator: (val) => val.length < 6 && val != confirm? 'Votre mot de passe et sa confirmation sont differente !!!': null,
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                    color: drawerBackgroundColor,
                    child: Row(
                      children: [
                       Icon( Icons.group_add)
                        ,
                        Text(
                      '  S\'enrégistrer',
                       style: TextStyle(color: Colors.white),
                      )
                      ],
                    ),
                    onPressed: () async {
                        if ( _formKey.currentState.validate() ) {

                          loading = true;

                          print('email: ${email} and password: ${password}');
                          dynamic result = await _auth
                                                      .registerWithEmailAndPassword(
                                                                                    nom: nom,
                                                                                    prenom: prenom,
                                                                                    telephone: telephone,                   
                                                                                    email: email,
                                                                                    role: role,
                                                                                    password: password
                                                        );

                          if( result == null ) {
                            setState(() {
                              error = 'Veuillez soumettre un émail valide !';
                              loading = false;
                            });
                          } else {
                             Navigator.of(context);
                             Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(  ) ));
                          }
                        }
                    } 
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
}