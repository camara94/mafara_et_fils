import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/user.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/authenticate/authenticate.dart';
import 'package:mafara_et_fils/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {
  final Utilisateur utilisateur;
  const Wrapper({this.utilisateur});

  @override
  Widget build(BuildContext context) {
    
    print(utilisateur);
    if( utilisateur == null ) {
     return Home(utilisateur: this.utilisateur,);
    } else {
      return Home(utilisateur: this.utilisateur,);
    }
  }
}