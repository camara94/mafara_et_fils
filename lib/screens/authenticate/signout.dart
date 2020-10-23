import 'package:flutter/material.dart';
import 'package:mafara_et_fils/services/auth.dart';
import 'package:mafara_et_fils/shared/constants.dart';

class SignOn extends StatefulWidget {
  SignOn({Key key}) : super(key: key);

  @override
  _SignOnState createState() => _SignOnState();
}

class _SignOnState extends State<SignOn> {
final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0.0,
          title: Text("Se Deconnecter à Ulysse Djerba"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric( vertical: 20.0, horizontal: 50.0 ) ,
          child: RaisedButton(
            child: Text('Se Deconnecter', style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold ),),
            color: kPrimaryColor,
            onPressed: () async {
              print('Se Deconnecter');
              dynamic result = await _auth.signOut();
              print(result);
              Navigator.of(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp( doc: null ) ));
            }
            ),
        ),
      ),
    );
  }
}