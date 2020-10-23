import 'package:flutter/material.dart';
import 'package:mafara_et_fils/services/auth.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          title: Text("Connection Anonyme"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric( vertical: 20.0, horizontal: 50.0 ) ,
          child: RaisedButton(
            child: Text('Se Connecter'),
            onPressed: () async {
              print('Connection anonyme');
              dynamic result = await _auth.signInAnon();
              if (result == null ) {
                print('Error sign in');
              } else {
                print(result.uid);
              }
            }
            ),
        ),
      ),
    );
  }
}