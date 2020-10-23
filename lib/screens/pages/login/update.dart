import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/login/constante.dart';
import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/screens/authenticate/register.dart';
import 'package:mafara_et_fils/screens/home/home.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/login/login.dart';
import 'package:mafara_et_fils/screens/pages/message.dart';

import 'package:mafara_et_fils/shared/loading.dart';
import 'package:mafara_et_fils/services/auth.dart';
import 'package:mafara_et_fils/services/database.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';


class Update extends StatefulWidget {
  final String email;
  final Function toogleView;
  String messageError;
  Update({ this.toogleView, this.email, this.messageError });
  @override
  _UpdateState createState() => _UpdateState(email: email);
}

class _UpdateState extends State<Update> {
  final _formKey = GlobalKey<FormState>();
  String messageError;
  final String email;
  _UpdateState({this.messageError, this.email});
  ScrollController scrollController;
  final AuthService _auth = AuthService();
   DatabaseService _db = null;
   List<Utilisateur> utilisateurs;
  // text field state
  String password = '';
  String confirmation='';
  String error =  '';
  bool loading = false;
  bool afficherPassword = true;
  bool afficherPassword2 = true;

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70),
          child: Text(
            'Bienvenue chez Manfara et fils',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

    Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(3),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: afficherPassword,
         validator: (val) => val.length < 6 && val != confirmation? 'Le mot de passe et sa confirmation doivent correspondre !!!': null,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: afficherPassword? MaterialButton(
            onPressed: (){ 
             setState(() {
                afficherPassword = !afficherPassword;
             });
           },
            child: Icon(
            Icons.remove_red_eye,
            size: 30.0,
            color: drawerBackgroundColor,//mainColor,visibility_off 
          ),
          ):MaterialButton(
            onPressed: (){ 
              setState(() {
                this.afficherPassword = !this.afficherPassword;
              });
              },
            child: Icon(
            Icons.visibility_off,
            size: 30.0,
            color: drawerBackgroundColor,//mainColor,visibility_off 
          ) ,
            ) ,
          labelText: 'Le mot de passe',

        ),
      ),
    );
  }

  Widget _buildConfirmationRow() {
     return Padding(
      padding: EdgeInsets.all(3),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: afficherPassword2,
        validator: (val) => val.length < 6 && val != email? 'Le mot de passe et sa confirmation doivent correspondre !!!': null,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        decoration: InputDecoration(
          prefixIcon: afficherPassword2? MaterialButton(
            onPressed: (){ 
             setState(() {
                afficherPassword2 = !afficherPassword2;
             });
           },
            child: Icon(
            Icons.remove_red_eye,
            size: 30.0,
            color: drawerBackgroundColor,//mainColor,visibility_off 
          ),
          ):MaterialButton(
            onPressed: (){ 
              setState(() {
                this.afficherPassword = !this.afficherPassword;
              });
              },
            child: Icon(
            Icons.visibility_off,
            size: 30.0,
            color: drawerBackgroundColor,//mainColor,visibility_off 
          ) ,
            ) ,
          labelText: 'La confirmation',

        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: EdgeInsets.only(bottom: 20),
          child: RaisedButton(
            elevation: 5.0,
            color: drawerBackgroundColor,//mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () async {
                        if ( _formKey.currentState.validate() ) {
                          print('Votre email: ${email} et votre password: ${password}');
                       setState(() {
                         loading = true;
                       });   
                          
                    var url = 'http://etablissementmanfaraetfils.com/apimanfara/updateUser.php?email=${email}&password=${password}';
                          var response = await http.get(url);
                         print('Response status: ${response.statusCode}');
                          print('Response body: ${response.body}');
                    Navigator.of(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage() ));
                                                
                  }
                                                                                 
            },
            child: Text(
              "Mettre à jour",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 50,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildOrRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 8.0),
          child: Text(
            '- OR -',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: drawerBackgroundColor, //mainColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0)
              ],
            ),
            child: Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContainer() {
    return this.loading == false? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Mettre à jour",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                      ),
                    ),
                  ],
                ),
                _buildPasswordRow(),
                _buildConfirmationRow(),
                _buildLoginButton()
              ],
            ),
          ),
        ),
      ],
    ): Loading();
  }

  Widget _buildSignUpBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 60),
          child: FlatButton(
            onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp(utilisateur: null,)));
             },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Avez-vous déjà un compte?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 60,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: ' Se connecter',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: MediaQuery.of(context).size.height / 60,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
           title: Text('Mettre à jour son mot de passe'), 
           backgroundColor: drawerBackgroundColor,
           actions: [
          RaisedButton(
          color: drawerBackgroundColor,
          onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
            },
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.white, size: 30,),
            ],
          ),
          )
         
        ],
           ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xfff2f3f7),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color:drawerBackgroundColor, //mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(70),
                    bottomRight: const Radius.circular(70),
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: ListView(
               // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildLogo(),
                  _buildContainer(),
                  _buildSignUpBtn()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}