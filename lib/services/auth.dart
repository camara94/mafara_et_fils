import 'package:firebase_auth/firebase_auth.dart';
import 'package:mafara_et_fils/model/user.dart';
import 'package:mafara_et_fils/model/utilisateur.dart';
import 'package:mafara_et_fils/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

 // create a user from FirebaseUser
  Users _userFromFirebaseUser( FirebaseUser user ) {
    return user != null ? Users(uid: user.uid, nom: user.displayName, 
                                prenom: user.displayName,
                                email: user.email, telephone: user.phoneNumber): null;
  }

   Utilisateur _utilisateurFromFirebaseUser( FirebaseUser user ) {
    return user != null ? Utilisateur( nom: user.displayName, 
                                prenom: user.displayName,
                                email: user.email, tel: user.phoneNumber): null;
  }


  // auth change obj user stream
  Stream<Users> get user {
    return _auth
                .onAuthStateChanged
                .map((FirebaseUser user) =>  _userFromFirebaseUser(user) );
               //or .map(_userFromFirebaseUser );
                
  }

   // auth change obj user stream
  Stream<Utilisateur> get utilisateur {
    return _auth
                .onAuthStateChanged
                .map((FirebaseUser user) =>  _utilisateurFromFirebaseUser(user) );
               //or .map(_userFromFirebaseUser );
                
  }

  // sign in anon
  Future signInAnon () async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch ( e ) {
      print(e);
      return null;
    }
  }

  // sign with email and password
  Future signWithEmailAndPassword( String email, String password ) async {
    try{
       AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
       FirebaseUser user = result.user;
        ///await DatabaseService(uid: user.uid)
       //return  _userFromFirebaseUser(user);
       print(user);
        return await DatabaseService(uid: user.uid ).getUserData();
    } catch( e ) {
      print(e);
      return null;
    }
  }

  //register email and password
  Future registerWithEmailAndPassword({
                                      String nom, 
                                      String prenom, 
                                      String cin, 
                                      String telephone,
                                      String role, 
                                      String email, 
                                      String password }) async {
    try{
       AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       FirebaseUser user = result.user;
       await DatabaseService(uid: user.uid).udpateUserData(nom, prenom, telephone, email, password, role);
       return  _userFromFirebaseUser(user);
    } catch( e ) {
      print(e);
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch ( e ) {
      print(e.toString());
      return null;
    }
  }
}