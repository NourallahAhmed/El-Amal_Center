import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as Sdk;

class Firebase {
  FirebaseAuth get auth => FirebaseAuth.instance;

  Stream<bool> get isLoggedIn => auth.authStateChanges().map((user) => user != null);

  Future<User?> logIn(AuthCredential authCredential) async {
    try {
      UserCredential userCredential = await auth.signInWithCredential(authCredential);
      return userCredential.user;
    } catch (exception, stackTrace) {
      //log error
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
    } on Exception catch (exception, stackTrace) {
      //log error
    }
  }

  static Future<void> init() async {
    await Sdk.Firebase.initializeApp();
  }
}