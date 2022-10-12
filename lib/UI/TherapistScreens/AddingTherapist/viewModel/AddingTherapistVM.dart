import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Model/TherapistData.dart';

class AddingTherapistVM with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var errorMsg = "";
  var listOfEmails = [];
  var check = false;
  final _firebaseStore = FirebaseFirestore.instance;


  Future<void> getAllMails() async{
    QuerySnapshot querySnapshot = await _firebaseStore.collection('Therapists').get();
    // Get data from docs and convert map to List
    final  allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element ) {
    var th = TherapistData.fromMap(element as Map<String, dynamic>);
    listOfEmails .add(th.mail);
    });
    notifyListeners();

  }


  Future<void> addTherapist(TherapistData therapist) async {
    print("CurrentUser");
    print(_auth.currentUser?.email.toString());
    //todo -> store in firebaseDatabase
    print(therapist.sessions);
     await FirebaseFirestore.instance.collection("Therapists").doc(therapist.mail).set(
        therapist.toJson()
    ).onError((error, stackTrace) => print("Error in fireStore ${error} , stackTrace ${stackTrace}"))
    .then((value)  async {
       //todo -> auth

       UserCredential userCredential = await _auth
           .createUserWithEmailAndPassword
         (email: therapist.mail, password: therapist.password)
           .catchError((error) {
         errorMsg = error.toString();
         print("error in creating the Auth ${errorMsg}");
       });
     }
     );
  }




  // Future<void> getAllTherapist() async {
  //   print("getAllTherapist");
  //
  //
  //
  //   //all documents inside therapists
  //   QuerySnapshot querySnapshot = await _firebaseStore.collection('Therapists').get();
  //
  //   // Get data from docs and convert map to List
  //   final  allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //
  //   allData.forEach((element ) {
  //     var th = TherapistData.fromMap(element as Map<String, dynamic>);
  //     listOfEmails .add(th.mail);
  //   });
  //
  //
  //
  //   //for a specific field
  //   // final allData =
  //   // querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();
  //   // onError: (e) => print("Error getting document: $e"),
  //   // );
  //   notifyListeners();
  // }


}