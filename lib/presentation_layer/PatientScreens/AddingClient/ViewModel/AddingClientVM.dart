import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../application_layer/utils/Constants.dart';
import '../../../../domain_layer/Model/patient.dart';
import '../../../../domain_layer/Model/TherapistModel.dart';
import '../../../../data_layer/data_source/Services/PushNotifictionServices.dart';
import '../../../../application_layer/utils/Shared.dart';

class AddingViewModel  with ChangeNotifier{

  FirebaseAuth _Firebase = FirebaseAuth.instance;

  DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final _firebaseStore = FirebaseFirestore.instance;
  List<Therapist> therapists = [];
   String clientTherapist = "";


   /// moved to networkClient (done) except  specialization part
  Future<void> getTherapistsMails() async {

      print("getAllTherapist");


      this.therapists.clear();
      //all documents inside therapists
      QuerySnapshot querySnapshot = await _firebaseStore.collection('Therapists').get();

      // Get data from docs and convert map to List
      final  allData = querySnapshot.docs.map((doc) => doc.data()).toList();

      allData.forEach((element ) {
        var th = Therapist.fromMap(element as Map<String, dynamic>);
        therapists.add(th);
      });

      print("before forEach");
      therapists.forEach((element) {
      print("in forEach");


      print("${element.specialization}");

      if (element.specialization == Specializations.Physiotherapist.name) {
        clientTherapist = element.name;
        print(clientTherapist);
        print(element.name);
      }
    notifyListeners();
    });

    print("after forEach");
    print(clientTherapist);
    print(therapists.map((e) => e.name));
      notifyListeners();
    }

  /// moved to networkClient (done)
  Future<void> updateTherapist(Therapist selectedTherapist, Patient patient) async{
    print("updateTherapist");

    var toJson = patient.toJson();
    var updatedList = patient.sessions.values.toList().first;

    selectedTherapist.sessions.addAll({patient.name: updatedList});

    print("updatedMap");
    print(selectedTherapist.sessions);

    var therapistToJson = selectedTherapist.toJson();
    var collection =  _firebaseStore.collection('Therapists');

    collection
        .doc(selectedTherapist.mail)
        .update({"sessions" : therapistToJson["sessions"]}) // <-- Updated data
        .then((_){
          print('Success');
          sendNotifiction(patient.name ,selectedTherapist.mail);
        })
        .catchError((error) => print('Failed: $error'));


    //for a specific field
    // final allData = querySnapshot.docs.map((doc) => doc.get('fieldName')).toList();
    // onError: (e) => print("Error getting document: $e"));
  }

  /// moved to networkClient (done)
  Future<void> addClient(Patient patient, Therapist selectedTherapist) async{

    print("addClient");
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Client/");


    // Store the email in the RealTimeDB
    await _databaseReference.push().set(
        patient.toJson()
    ).onError((error, stackTrace) =>
    print("Error will set patient ${error}  stackTrace = ${stackTrace}"));

    updateTherapist(selectedTherapist, patient);
    print("addClient");
  }


  /// moved to networkClient (done)
  sendNotifiction(String patientName  , String email) async {


    print("email ${email}");
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("Tokens")
        .doc(email) //email
        .get();

    String token = snap['token'];

    print('token from login = ${token}');

    PNServices.sendPushMessage(token, """
    Check the new session for ${
    patientName
    }
    """, "Al Amal Center");
  }

  getUserName() =>  SharedPref.userName;



}