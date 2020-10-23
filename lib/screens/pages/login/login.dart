import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mafara_et_fils/screens/authenticate/updatepassword.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/screens/pages/login/sign_up.dart';
import 'package:mafara_et_fils/screens/pages/login/constante.dart';
import 'package:mafara_et_fils/main.dart';

import 'package:mafara_et_fils/shared/loading.dart';
import 'package:mafara_et_fils/services/auth.dart';
import 'package:mafara_et_fils/services/database.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';


class LoginPage extends StatefulWidget {
  final Function toogleView;
  String messageError;
  LoginPage({ this.toogleView, this.messageError });
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String messageError;
  _LoginPageState({this.messageError});
  ScrollController scrollController;
  final AuthService _auth = AuthService();
   DatabaseService _db = null;
   List<Utilisateur> utilisateurs;
  // text field state
  String email =  '';
  String password = '';
  String error =  '';
  bool loading = false;
  bool afficherPassword = true;

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

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        validator: (val) => val.isEmpty ? 'Entrez votre émail ou Existant dans notre base de donnée': null,
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: MaterialButton(
              onPressed: null,
              child: Icon(
              Icons.email,
              size: 30.0,
              color: drawerBackgroundColor ,//mainColor,
            ),
              ),
            labelText: 'E-mail'),
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: afficherPassword,
        validator: (val) => val.length < 3 ? 'Votre mot de passe doit depasser 6 caractères': null,
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

  Widget _buildForgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdatePassword()));
          },
          child: Text("Oublier le mot de passe"),
        ),
      ],
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
            },
            child: Text(
              "Login",
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                      ),
                    ),
                  ],
                ),
                _buildEmailRow(),
                _buildPasswordRow(),
                _buildForgetPasswordButton(),
                _buildLoginButton(),
               // _buildOrRow(),
                _buildSocialBtnRow(),
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
          padding: EdgeInsets.only(top: 40),
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignUp()));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'N\'avez-vous pas de compte?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height / 60,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: ' S\'enregistrer',
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
           title: Text('Login'), 
           backgroundColor: drawerBackgroundColor,
           actions: [
          RaisedButton(
          color: drawerBackgroundColor,
          onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignUp()));
            },
          child: Row(
            children: [
              Icon(Icons.group_add, color: Colors.white, size: 30,),
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
                  _buildSignUpBtn(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}