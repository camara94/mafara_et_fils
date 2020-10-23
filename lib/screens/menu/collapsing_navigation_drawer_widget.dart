import 'package:mafara_et_fils/main.dart';
import 'package:mafara_et_fils/model/user.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/screens/authenticate/register.dart';
import 'package:mafara_et_fils/screens/pages/liste_produit.dart.dart';
import 'package:mafara_et_fils/screens/pages/login/login.dart';
import 'package:mafara_et_fils/screens/pages/page_apropos.dart';
import 'package:mafara_et_fils/screens/pages/panier.dart';
import 'package:provider/provider.dart';

import 'custom_navigation_drawer.dart';
import 'package:flutter/material.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  Utilisateur utilisateur;
  CollapsingNavigationDrawer({this.utilisateur});
  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState(utilisateur: this.utilisateur);
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
  
  with SingleTickerProviderStateMixin {
  Utilisateur utilisateur;

  CollapsingNavigationDrawerState({this.utilisateur});   

  double maxWidth = 210;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;
  List<NavigationModel> navigationItems = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);

        if (utilisateur != null) {
          navigationItems = [
          NavigationModel(title: "Accueil", icon: Icons.home, act: (BuildContext c){}),
          NavigationModel(title: "Produits", icon: Icons.list, act: (BuildContext c){}),
          NavigationModel(title: "Mon panier", icon: Icons.shopping_basket, act: (c){}),
          NavigationModel(title: "Apropos", icon: Icons.info, act: (BuildContext c){}),
          NavigationModel(title: "LogOut", icon: Icons.exit_to_app, act: (BuildContext c){}),
        ];
      } else if(utilisateur == null) {
         navigationItems = [
          NavigationModel(title: "Accueil", icon: Icons.home, act: (BuildContext c){}),
          NavigationModel(title: "Produits", icon: Icons.list, act: (BuildContext c){}),
          NavigationModel(title: "Mon panier", icon: Icons.shopping_basket, act: (c){}),
          NavigationModel(title: "Apropos", icon: Icons.info, act: (BuildContext c){}),
          NavigationModel(title: "Login", icon: Icons.person, act: (BuildContext c){})
        ];
      }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        width: widthAnimation.value + 50,
        color: drawerBackgroundColor,
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: Colors.brown[500],
                        image: DecorationImage(
                            image: AssetImage( 'assets/nainy.png' ),
                            fit: BoxFit.cover)),
                    height: MediaQuery.of(context).size.width/7,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Column(
                        children: [    
                          Text('Manfara et Fils', style:  TextStyle(color: Colors.green[600], fontSize: 22),),
                          Text(utilisateur !=null? utilisateur.prenom:'', style:  TextStyle(color: Colors.white, fontSize: 22),),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            //CollapsingListTile(title: 'Naïny Bérété', icon: Icons.person, animationController: _animationController ),
            Divider(color: Colors.grey, height: 40.0,),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, counter) {
                  return Divider(height: 12.0);
                },
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                      onTap: () {
                        setState(() {
                          currentSelectedIndex = counter;
                           
                        });
                        switch(counter){
                          case 0:{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyApp(utilisateur:utilisateur)));} 
                            ; break;
                          case 1:{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ListeProduit(utilisateur:utilisateur)));
                            } 
                            ; break;
                          case 2:{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> utilisateur != null? Panier(utilisateur:utilisateur): LoginPage()));} ; break;
                             case 3:{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PageApropos() ));
                            } ; break;
                             case 4:{
                               if(utilisateur != null)
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyApp(utilisateur: null)));
                                if(utilisateur == null)
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
                                } ; break;   
                        }
                      },
                      isSelected: currentSelectedIndex == counter,
                      title: navigationItems[counter].title,
                      icon: navigationItems[counter].icon,
                      act: navigationItems[counter].act,
                      animationController: _animationController,
                  );
                },
                itemCount: navigationItems.length,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _animationController,
                color: selectedColor,
                size: 50.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  
}

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
