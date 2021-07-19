import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static Future<UserCredential> signUp(String email, String password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> signIn(String email, String password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut(){
    return FirebaseAuth.instance.signOut();
  }
}
