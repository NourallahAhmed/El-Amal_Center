import 'package:ElAmlCenter/data_layer/model/therapist_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../../application_layer/utils/Shared.dart';
import '../../model/patient_response.dart';
import '../Services/PushNotifictionServices.dart';

abstract class BaseNetworkClient {
  Future addPatient(
      PatientResponse patientResponse, TherapistResponse therapistResponse);

  Future addTherapist(TherapistResponse therapistResponse);

  Future deleteTherapist(TherapistResponse therapistResponse);

  Future updateTherapist(
      PatientResponse patientResponse, TherapistResponse therapistResponse);

  Future sendNotification(String email, String patientName);

  Future<List<PatientResponse>> fetchPatients();

  Future<List<PatientResponse>> fetchPatientsForCurrentTherapist();

  Future<List<TherapistResponse>> fetchTherapists();

  Future<Map<String, dynamic>> fetchSessionsForSpecificTherapists();
}

class NetworkClient extends BaseNetworkClient {
  //todo : dependency injection using getit
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _auth;

  NetworkClient(this._firebaseFirestore, this._firebaseDatabase, this._auth);

  @override
  Future<List<PatientResponse>> fetchPatients() async {
    // TODO: implement fetchPatients
    throw UnimplementedError();
  }

  @override
  Future<List<TherapistResponse>> fetchTherapists() async {
    List<TherapistResponse> therapists = [];
    final document = await _firebaseFirestore.collection("Therapists").get();

    final allTherapists = document.docs.map((doc) => doc.data()).toList();

    for (var therapist in allTherapists) {
      therapists.add(TherapistResponse.fromJson(therapist));
    }

    return therapists;
  }

  @override
  Future<List<PatientResponse>> fetchPatientsForCurrentTherapist() async {
    final List<PatientResponse> listOfPatientsForCurrentTherapist = [];
    final snapshot = await _firebaseDatabase.ref('Client/').get();

    final allPatients = snapshot.value as Map<dynamic, dynamic>;

    allPatients.forEach((key, value) {
      final patient = PatientResponse.fromJson(value);
      if (SharedPref.email == "${patient.therapist}@elamalcenter.com") {
        listOfPatientsForCurrentTherapist.add(patient);
      }
    });

    return listOfPatientsForCurrentTherapist;
  }

  @override
  Future<Map<String, dynamic>> fetchSessionsForSpecificTherapists() async {
    var collection = await _firebaseFirestore.collection('Therapists');
    final data = await collection.doc(SharedPref.email).get();
    final listOfSessionsForTherapist = data.data()!["sessions"];
    return listOfSessionsForTherapist;
  }

  @override
  Future sendNotification(String email, String patientName) async {
    final DocumentSnapshot snapShot = await _firebaseFirestore
        .collection("Tokens")
        .doc(email) //email
        .get();

    final String token = snapShot['token'];

    PNServices.sendPushMessage(
        token, "Check the new session for $patientName", "Al Amal Center");
  }

  @override
  Future addPatient(PatientResponse patientResponse,
      TherapistResponse therapistResponse) async {
    final document = await _firebaseDatabase.ref("Client/");
    await document.push().set(patientResponse.toJson()).onError(
        (error, stackTrace) =>
            print("Error will set patient $error stackTrace = $stackTrace"));

    ///then update therapist
    updateTherapist(patientResponse, therapistResponse);
  }

  @override
  Future updateTherapist(PatientResponse patientResponse,
      TherapistResponse therapistResponse) async {
    final collection = _firebaseFirestore.collection("Therapists");
    final listOfSessionForNewPatient =
        patientResponse.sessions.values.toList().first;

    //update the List Of Sessions for the Therapist
    therapistResponse.sessions
        .addAll({patientResponse.name: listOfSessionForNewPatient});

    collection.doc(therapistResponse.mail).update({
      "sessions": therapistResponse.toJson()["sessions"]
    }) // <-- Updated data
        .then((_) {
      if (kDebugMode) {
        print('Success');
      }

      // send notification
      sendNotification(patientResponse.name, therapistResponse.mail);
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed: $error');
      }
    });
  }

  @override
  Future addTherapist(TherapistResponse therapistResponse) async {
    await FirebaseFirestore.instance
        .collection("Therapists")
        .doc(therapistResponse.mail)
        .set(therapistResponse.toJson())
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print("Error in fireStore $error , stackTrace $stackTrace");
      }
    }).then((value) async {
      //todo -> auth

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
              email: therapistResponse.mail,
              password: therapistResponse.password)
          .catchError((error) {
        if (kDebugMode) {
          print("error in creating the Auth $error");
        }
      });
    });
  }

  @override
  Future deleteTherapist(TherapistResponse therapistResponse) async {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: therapistResponse.mail,
            password: therapistResponse.password);
    final user = userCredential.user;
    await user?.delete().then((value) async {
      await _firebaseFirestore
          .collection('Therapists')
          .doc(therapistResponse.mail)
          .delete();
    });
  }
}
