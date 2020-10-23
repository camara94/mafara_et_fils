import 'package:flutter/material.dart';
import 'package:mafara_et_fils/screens/menu/theme.dart';
import 'package:provider/provider.dart';
import 'package:mafara_et_fils/model/user.dart';

class AutreMenu extends StatefulWidget {
  @override
  _AutreMenuState createState() => _AutreMenuState();
}

class _AutreMenuState extends State<AutreMenu> {
  @override
  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    return  new Drawer(
        child: new ListView(
          children: <Widget>[
//            header
            new UserAccountsDrawerHeader(
                accountName: Text('Nanfara et Fils'),
                accountEmail: Text(user.email == null ? 'ldamaro@gmail.com': user.email),
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                backgroundColor: Colors.grey,
                child: Image.asset('assets/nainy.png', color: Colors.white,),
              ),
            ),
            decoration: new BoxDecoration(
              color: drawerBackgroundColor,
            ),
            ),

//            body

          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('Home Page'),
              leading: Icon(Icons.home),
            ),
          ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My account'),
                leading: Icon(Icons.person),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My Orders'),
                leading: Icon(Icons.shopping_basket),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Categoris'),
                leading: Icon(Icons.dashboard),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite),
              ),
            ),

            Divider(),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings, color: Colors.blue,),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('About'),
                leading: Icon(Icons.help, color: Colors.green),
              ),
            ),
          ],
        ),
      );
  }
}