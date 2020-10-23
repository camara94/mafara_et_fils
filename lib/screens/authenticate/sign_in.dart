import 'package:flutter/material.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:mafara_et_fils/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 200.0),
        child: RaisedButton(
          color: drawerBackgroundColor,
          onPressed:() async {
            dynamic result = await _auth.signInAnon();
            if( result == null ) {
              print('Error sign In');
            } else {
              print(result);
            }
           
          } , 
          child: Text('Sign in Anonn', style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}