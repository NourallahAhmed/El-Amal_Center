


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/utils/Shared.dart';

import 'FireBase.dart';
import 'Google.dart';

class LoginViewModel  with ChangeNotifier{


  var erroeMsg  = "" ;
  var isStored  = false ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignin = GoogleSignIn();


  //Store the name of the therapist in the RealTimeDB
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  //todo store the gmail too when it works
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Therapist/");

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
      addToTherapist(email);
    }

  }

  Future<void> login( String email , String password) async {
    print("Login");
    var id = UniqueKey().hashCode.toString();
    final prefs = await SharedPreferences.getInstance();
    erroeMsg = "";

    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password)
        .catchError( ( error ) {
        print(error);
        erroeMsg = error.toString();});
      storeData(email, password);

  }
  IsStored() => isStored;
  Future<void> loginGmail () async {
    AuthCredential? authCredential = await _google.logIn();
    await _firebase.logIn(authCredential!);

  }

  Future<void> logOut() async{



    await  SharedPref.pref.clear();
    print("logout");
    print( SharedPref.pref.getString("email"));
    await FirebaseAuth.instance.signOut();
  }

  //todo: Store the email in the RealTimeDB

  Future<void> addToTherapist(String email) async{
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Therapist/");
    await _databaseReference.push().set({
      "name" :  email
    });
  }

  Future<void> storeData(String email , String password) async {
    print("StoreData");
    var id = UniqueKey().hashCode.toString();
    // final prefs = await SharedPreferences.getInstance();
    await SharedPref.pref.setString("email", email);
    await  SharedPref.pref.setString("password", password);
    await  SharedPref.pref.setString("uniquekey", id);
    isStored = true;
    notifyListeners();
  }

  String getError() => erroeMsg.isNotEmpty ? erroeMsg.substring(erroeMsg.toString().lastIndexOf("]")) : "";








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