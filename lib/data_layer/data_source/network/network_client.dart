import 'package:ElAmlCenter/data_layer/data_source/network/failure.dart';
import 'package:ElAmlCenter/data_layer/model/therapist_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../../../application_layer/utils/Shared.dart';
import '../../model/patient_response.dart';
import '../Services/PushNotifictionServices.dart';

abstract class BaseNetworkClient {
  Future<Either<Failure, PatientResponse>> addPatient(
      PatientResponse patientResponse, TherapistResponse therapistResponse);

  Future<Either<Failure, TherapistResponse>> addTherapist(
      TherapistResponse therapistResponse);

  Future<Either<Failure, bool>> deleteTherapist(
      TherapistResponse therapistResponse);

  Future<Either<Failure, bool>> updateTherapist(
      PatientResponse patientResponse, TherapistResponse therapistResponse);

  Future sendNotification(String email, String patientName);

  Future<Either<Failure, List<PatientResponse>>> fetchPatients();

  Future<Either<Failure, List<PatientResponse>>>
      fetchPatientsForCurrentTherapist();

  Future<Either<Failure, List<TherapistResponse>>> fetchTherapists();

  Future<Either<Failure, Map<String, dynamic>>>
      fetchSessionsForSpecificTherapists();
}

class NetworkClient extends BaseNetworkClient {
  //todo : dependency injection using getit
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _auth;

  NetworkClient(this._firebaseFirestore, this._firebaseDatabase, this._auth);

  @override
  Future<Either<Failure, List<PatientResponse>>> fetchPatients() async {
    List<PatientResponse> listOfPatients = [];
    final snapshot = await _firebaseDatabase.ref('Client/').get();

    if (snapshot.exists) {
      final allPatients = snapshot.value as Map<dynamic, dynamic>;

      allPatients.forEach((key, value) {
        final patient = PatientResponse.fromJson(value);
        listOfPatients.add(patient);
      });

      return right(listOfPatients);
    } else {
      return Left(Failure(404, "not found"));
    }
  }

  @override
  Future<Either<Failure, List<TherapistResponse>>> fetchTherapists() async {
    List<TherapistResponse> therapists = [];
    final document = await _firebaseFirestore.collection("Therapists").get();

    if (document.docs.isNotEmpty) {
      final allTherapists = document.docs.map((doc) => doc.data()).toList();

      for (var therapist in allTherapists) {
        therapists.add(TherapistResponse.fromJson(therapist));
      }

      return Right(therapists);
    } else {
      return Left(Failure(404, "Documents is empty"));
    }
  }

  @override
  Future<Either<Failure, List<PatientResponse>>>
      fetchPatientsForCurrentTherapist() async {
    final List<PatientResponse> listOfPatientsForCurrentTherapist = [];
    final snapshot = await _firebaseDatabase.ref('Client/').get();

    if (snapshot.exists) {
      final allPatients = snapshot.value as Map<dynamic, dynamic>;
      print("allPatients  : $allPatients");
      allPatients.forEach((key, value) {
        print("Value = $value");
        final patient = PatientResponse.fromJson(value);
        if (SharedPref.email == "${patient.therapist}@elamalcenter.com") {
          listOfPatientsForCurrentTherapist.add(patient);
        }
      });

      return right(listOfPatientsForCurrentTherapist);
    } else {
      return Left(Failure(404, "not found"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>>
      fetchSessionsForSpecificTherapists() async {
    var collection = _firebaseFirestore.collection('Therapists');
    final data = await collection.doc(SharedPref.email).get();

    if (data.exists) {
      final listOfSessionsForTherapist = data.data()!["sessions"];
      return right(listOfSessionsForTherapist);
    } else {
      return Left(Failure(404, "not exist"));
    }
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
  Future<Either<Failure, PatientResponse>> addPatient(PatientResponse patientResponse,
      TherapistResponse therapistResponse) async {
    var errors = "";
    final document = _firebaseDatabase.ref("Client/");
    await document.push().set(patientResponse.toJson()).onError(
        (error, stackTrace) =>
            errors = "Error will set patient $error stackTrace = $stackTrace");

    ///then update therapist
    updateTherapist(patientResponse, therapistResponse);
    return errors == "" ?  Right(patientResponse) : Left(Failure(404, errors));
  }

  @override
  Future<Either<Failure, bool>> updateTherapist(PatientResponse patientResponse,
      TherapistResponse therapistResponse) async {
    var errors = "";
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
        errors = error;
      }
    });
    return errors != "" ? Left(Failure(202, errors)) : const Right(true);
  }

  @override
  Future<Either<Failure, TherapistResponse>> addTherapist(
      TherapistResponse therapistResponse) async {
    var errors = "";
    await FirebaseFirestore.instance
        .collection("Therapists")
        .doc(therapistResponse.mail)
        .set(therapistResponse.toJson())
        .onError((error, stackTrace) {
      if (kDebugMode) {
        errors = "Error in fireStore $error , stackTrace $stackTrace";
      }
    }).then((value) async {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
              email: therapistResponse.mail,
              password: therapistResponse.password)
          .catchError((error) {
        if (kDebugMode) {
          errors += "error in creating the Auth $error";
          print("error in creating the Auth $error");
        }
      });
    });

    return errors != "" ? Left(Failure(404, errors)) :  Right(therapistResponse);
  }

  @override
  Future<Either<Failure, bool>> deleteTherapist(
      TherapistResponse therapistResponse) async {
    var errors = "";
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: therapistResponse.mail,
            password: therapistResponse.password);
    final user = userCredential.user;
    await user?.delete().then((value) async {
      await _firebaseFirestore
          .collection('Therapists')
          .doc(therapistResponse.mail)
          .delete()
          .onError((error, stackTrace) =>
              errors = " error $error and stacktrace = $stackTrace");
    });

    return errors != "" ? Left(Failure(404, errors)) : const Right(true);
  }
}
