import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mafara_et_fils/shared/loading.dart';

class Categories {
  final String id;
  final String nom;
  final String image;
  Categories({this.id, this.nom, this.image});
}


class HorizontalList extends StatefulWidget {
  const HorizontalList({Key key}) : super(key: key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

List<dynamic> listCategories = [];
List<Categories> categories = [];
  void initState() {
    super.initState();
    getCategoriesFromFirebase();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return categories.length>0 ? Container(
        height: 100.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Category(
              image_caption: categories[0].nom,
              image_location: categories[0].image,
            ),
             Category(
              image_caption: categories[1].nom,
              image_location: categories[1].image,
            ),
             Category(
              image_caption: categories[2].nom,
              image_location: categories[2].image,
            ),
             Category(
              image_caption: categories[3].nom,
              image_location: categories[3].image,
            ),
          ],
          
        ),
    ): Container(
      height: 100.0,
      child: Loading(),
    );
  }

  void  getCategoriesFromFirebase()  {
      setState(() {  
          Firestore.instance.collection("category").getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            listCategories.add(result.data);
          });
          setState(() { });
          listCategories.forEach((e) {print(e['nom']); });
      });
    }); 
  }

  void _getCategories() async {
    var url = 'http://etablissementmanfaraetfils.com/apimanfara/getCategory.php';
    var response = await http.get(url);
     print('Autre Response status: ${response.statusCode}');
     print('Autre Response body: ${jsonDecode(response.body)[0].length}');
    setState(() {      
      for(int i=0; i <jsonDecode(response.body)[0].length; i++ ) {
        categories.add(new Categories(
            id:jsonDecode(response.body)[0][i]['id'], 
            nom: jsonDecode(response.body)[0][i]['nom'], 
            image: jsonDecode(response.body)[0][i]['image'],
            
          ));
    }
    print('dans la page card Categories: ${categories}');
   });
      setState(() { });
  }
}

class Category extends StatelessWidget {
  final image_location;
  final image_caption;
  const Category({this.image_caption, this.image_location});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){},
        child: Container(
          width: MediaQuery.of(context).size.width/4,
          height: MediaQuery.of(context).size.height/4,
          child: ListTile(
            title: Image.asset(this.image_location, height: 80),
            subtitle: Text(this.image_caption),   
          ),
        ),
      ),
    );
  }
}