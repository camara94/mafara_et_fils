import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/authenticate/register.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';


class NavigationModel {
  String title;
  IconData icon;
  Function act;
  BuildContext c;
  Utilisateur utilisateur;

  NavigationModel({this.title, this.icon, this.act, this.c, this.utilisateur});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Accueil", icon: Icons.home, act: (BuildContext c){}),
  NavigationModel(title: "Produits", icon: Icons.list, act: (BuildContext c){}),
  NavigationModel(title: "Mon panier", icon: Icons.shopping_basket, act: (c){}),
  NavigationModel(title: "Apropos", icon: Icons.info, act: (BuildContext c){}),
  NavigationModel(title: "LogOut", icon: Icons.exit_to_app, act: (BuildContext c){}),
  NavigationModel(title: "Login", icon: Icons.person, act: (BuildContext c){})
];

 