import 'package:flutter/material.dart';
import 'package:mafara_et_fils/screens/authenticate/register.dart';
import 'package:mafara_et_fils/screens/authenticate/signinwithemail.dart';
import 'package:mafara_et_fils/screens/pages/login/login.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toogleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if ( showSignIn ) {
      return Container(
       child: LoginPage() //SignInWithEmail(toogleView: toogleView)
      );
    } else {
      return Container(
        child: Register(toogleView: toogleView)
      );
    }

  }
}