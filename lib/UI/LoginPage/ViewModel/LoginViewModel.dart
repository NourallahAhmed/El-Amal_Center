


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FireBase.dart';
import 'Google.dart';

class LoginViewModel {


  var erroeMsg  = "" ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignin = GoogleSignIn();


  //Store the name of the therapist in the RealTimeDB


  FirebaseDatabase _database = FirebaseDatabase.instance;

  //todo store the gmail too when it works
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Therapist/");

  final Firebase _firebase = Firebase();
  final Google _google = Google();

  Future<void> createAccount(  String email ,   String password) async {

    erroeMsg = "";
    print("Create Account");

    UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword
        (email: email, password: password)
        .catchError( ( error ) {
          erroeMsg = error.toString();
        });

    if (erroeMsg.isEmpty){
      // Obtain shared preferences.
      storeData(email , password);
    }

  }

  Future<void> storeData(String email , String password) async {
    var id = UniqueKey().hashCode.toString();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    await prefs.setString("password", password);
    await prefs.setString("uniquekey", id);

    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Therapist/${id}");

    //Store the email in the RealTimeDB
    await _databaseReference.set({
      "name" :  email
    });
  }


  Future<void> login( String email , String password) async {
    print("Login");
    erroeMsg = "";
    UserCredential userCredential = await _auth.signInWithEmailAndPassword
      (email: email, password: password)
        .catchError( ( error ) {
      print(error);
      erroeMsg = error.toString();
    });

  }


  String getError() {
    return  erroeMsg.isNotEmpty ? erroeMsg.substring(erroeMsg.toString().lastIndexOf("]")) : "";
  }

  Future<void> loginGmail () async {
    AuthCredential? authCredential = await _google.logIn();
    await _firebase.logIn(authCredential!);

  }


  // Future<void> loginByGmail() async {
  //   print("Login By Gmail");
  //
  //   GoogleSignInAccount? googleSignInAccount = await _googleSignin.signIn().catchError( (e) => print("error signin ${e}"));
  //
  //
  //   print("googlesigninaccount");
  //   print(googleSignInAccount);
  //
  //   GoogleSignInAuthentication? googleSignInAuthentication =
  //   await googleSignInAccount?.authentication.catchError( (e) =>print("error googleSignInAuthentication ${e}"));
  //
  //
  //
  //
  //   print("googleSignInAuthentication");
  //   print(googleSignInAuthentication);
  //
  //
  //   AuthCredential authCredential = GoogleAuthProvider.credential(
  //       idToken: googleSignInAuthentication?.idToken,
  //       accessToken: googleSignInAuthentication?.accessToken);
  //
  //   UserCredential authResult = await _auth.signInWithCredential(authCredential).catchError( (e) => print(e));
  //
  //   User user =  await _auth.currentUser!;
  //
  //   print('user email = ${user.email}');
  // }
  //
  // Future<void> signOut() async {
  //   await _googleSignin.signOut();
  //   print('sign out');
  // }




///todo :
/// sign out
/// // Remove data for the 'counter' key.
// final success = await prefs.remove('counter');



}