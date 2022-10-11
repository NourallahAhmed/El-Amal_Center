import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Model/Client.dart';

import '../../../Services/PushNotifictionServices.dart';
import '../../../utils/Shared.dart';

class HomePageVM with ChangeNotifier {
  //todo fetch the data related to the therpist by email
  final List<Patient> listOfAllClients = [];
  final List<Patient> _listOfTodaysClients = [];
  final Map<DateTime,List<Patient>> listOfClients = {};

  Future<void> fetchAllData() async {
    print("Fetch All Data");

    var email =  SharedPref.email;

    final snapshot = await FirebaseDatabase.instance.ref('Client/').get();

    final map = snapshot.value as Map<dynamic, dynamic>;
    print("snapShot = ${map}");
    map.forEach((key, value) {
      final client = Patient.fromMap(value);
      print(client.name);
      if (client.therapist == email){

        print("therapist Email ${email}");
        listOfAllClients.add(client);
      }
    });
    buildTheList(listOfAllClients);








    // notifyListeners();
  }


  void buildTheList( List<Patient> clients){

    print("buildList");

    //outer Loop over the clients
    clients.forEach((client) {



      client.sessions.forEach((key, listOfSession) {

        print("forEach in home page vm through the map string and List <DT>");
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
    print(listOfClients);
  }


  getClientsList() => listOfAllClients;

  String? getCurrentUser() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email.toString().substring(0,user.email?.lastIndexOf("@")) : null;
  }


}