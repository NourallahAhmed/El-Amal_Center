import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../domain_layer/Model/patient.dart';
import '../../../../application_layer/utils/Shared.dart';

class HomePageVM with ChangeNotifier {
  //todo fetch the data related to the therpist by email

  //MARK if the user is the admain and want to show all the client as well
  final List<Patient> listOfAllClients = [];

  final Map<DateTime,List<Patient>> listOfClients = {};


  Map<String,List<DateTime>> listOfTherapistClients = {};



  final _firebaseStore = FirebaseFirestore.instance;



  /// moved to networkClient (done) except the buildTheListForLoggedInTherapist
  Future<void> fetchAllData() async {

    final snapshot = await FirebaseDatabase.instance.ref('Client/').get();

    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      final client = Patient.fromMap(value);
      if (SharedPref.email == "${client.therapist}@elamalcenter.com"){
        listOfAllClients.add(client);
      }
    });
    buildTheListForLoggedInTherapist(listOfAllClients);
  }


  void buildTheListForLoggedInTherapist( List<Patient> clients){


    //outer Loop over the clients
    clients.forEach((client) {
      client.sessions.forEach((key, listOfSession) {
        // inner loop over the sessions for each case
        listOfSession.forEach((session) {
          if (listOfClients.containsKey(DateTime(session.year,session.month, session.day, 00, 0).toLocal())) {
            if (listOfClients[DateTime(session.year, session.month, session.day, 00, 0).toLocal()]!.contains(client) == false ) {
              listOfClients.update(
                  DateTime(session.year, session.month,
                      session.day, 00, 0).toLocal(),
                      (value) => value + [client]);
            }

          }
          else {
            Map<DateTime, List<Patient>> instance = {
              DateTime(session.year,session.month,
                  session.day , 00, 0).toLocal(): [
                client,
              ]
            };
            listOfClients.addAll(instance);
          }
        });
      });
    });
    notifyListeners();
  }


  getClientsList() => listOfAllClients;


  String? getCurrentUser() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email.toString().substring(0,user.email?.lastIndexOf("@")) : null;
  }

  /// moved to networkClient (done)

  Future<void> fetchSpecificTherapist() async {
    // for a specific field
    var collection =  _firebaseStore.collection('Therapists');
    final allData = await collection.doc(SharedPref.email).get();
    print("fetchSpecficTherapist");
    var therapistPatients = allData.data()!["sessions"];

    listOfTherapistClients = therapistPatients;
    print(therapistPatients);
  }

}