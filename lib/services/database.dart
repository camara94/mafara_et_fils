import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/model/sliders.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  
  // collection reference
  final CollectionReference utilisateurCollection = Firestore
                                                             .instance
                                                             .collection('utilisateurs');
  final CollectionReference sliderCollection = Firestore
                                                             .instance
                                                             .collection('slider');
  

                                                             
  Future udpateUserData(
                        String nom, 
                        String prenom, 
                        String telephone, 
                        String email, 
                        String password, 
                         String role 
                        ) async {
    return await utilisateurCollection.document(uid).setData({
      'nom':nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'password': password,
      'role': role
    });
  }

   Future getUserData() async {
    return await utilisateurCollection.document(uid).get();
  }

  Future getSliderData() async {
    return await sliderCollection.document(uid).get();
  }

  // utilisateur list from snapshot
  List<Utilisateur> _utilisateurListFromSnapshot ( QuerySnapshot  snapshot) {
    return snapshot.documents.map((doc){
        return Utilisateur( 
                            nom: doc.data['nom'] ?? '',
                            prenom: doc.data['prenom']?? '',  
                            tel: doc.data['tel']?? '',
                            email: doc.data['email']?? '',
                            username: doc.data['username']?? '',
                            password: doc.data['password']?? '',
                            role: doc.data['role']?? '',
          ); 
    } ).toList();
  }


  

  // get utilisateurs stream
  Stream<List<Utilisateur>> get utilisateurs {
    return utilisateurCollection
                                .snapshots()
                                .map(( _utilisateurListFromSnapshot));

  }

  // get user doc stream
  Stream<DocumentSnapshot> get userData {
    return utilisateurCollection.document(uid).snapshots();
  }


   // Slider list from snapshot
  List<Sliders> _sliderListFromSnapshot ( QuerySnapshot  snapshot) {
    return snapshot.documents.map((doc){
        return Sliders( 
                            id: doc.data['id'] ?? '',
                            name: doc.data['name']?? '',  
                            image: doc.data['image']?? '',
          ); 
    } ).toList();
  }

  // get slider doc stream
  Stream<DocumentSnapshot> get sliderData {
    return sliderCollection.document(uid).snapshots();
  }

}