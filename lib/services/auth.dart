import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // sign in anon
  Future signInAnonn() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch( e ) {
      print(e.toString());
      return null;
    }
  }
    
  //sign in with email et password
      
  //register with email et password
      
  //sign out
    
}     
     