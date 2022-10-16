import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Model/TherapistData.dart';

class All_TherapistVM with ChangeNotifier {

  List<TherapistData> Therapists = [];

  final _firebaseStore = FirebaseFirestore.instance;
  Future<void> getAllTherapist() async {
    print("getAllTherapist");


    this.Therapists.clear();
   //all documents inside therapists
    QuerySnapshot querySnapshot = await _firebaseStore.collection('Therapists').get();

    // Get data from docs and convert map to List
    final  allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    allData.forEach((element ) {
    var th = TherapistData.fromMap(element as Map<String, dynamic>);
    Therapists.add(th);
    });


    //todo for display
    //for a specific field
    // final allData =
    // querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();
     // onError: (e) => print("Error getting document: $e"),
    // );
    notifyListeners();
  }


  Future<void> deleteTherapist( TherapistData therapist) async {
    // delete form auth and firestore
     print("deleteTherapist");
    //from Auth
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: therapist.mail, password: therapist.password);
    final user = userCredential.user;
    await user?.delete().then((value) async {
      //from FireStore
      await _firebaseStore.collection('Therapists')
          .doc(therapist.mail)
          .delete();
      print("deleted");
      this.Therapists.remove(therapist);
      notifyListeners();

    }
    );



  }

}