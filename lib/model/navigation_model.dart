import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;

  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Accueil", icon: Icons.insert_chart),
  NavigationModel(title: "Produits", icon: Icons.library_books),
  NavigationModel(title: "Panier", icon: Icons.shopping_basket),
  NavigationModel(title: "Log In", icon: Icons.verified_user),
  NavigationModel(title: "Apropos", icon: Icons.settings),
];