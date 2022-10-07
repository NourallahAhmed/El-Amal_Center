import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Model/Client.dart';

import '../../../utils/Shared.dart';

class HomePageVM with ChangeNotifier {
  //todo fetch the data related to the therpist by email
  final List<Client> listOfAllClients = [];
  final List<Client> _listOfTodaysClients = [];
  final Map<DateTime,List<Client>> listOfClients = {};

  Future<void> fetchAllData() async {
    print("Fetch All Data");

    var email =  SharedPref.email;

    final snapshot = await FirebaseDatabase.instance.ref('Client/').get();

    final map = snapshot.value as Map<dynamic, dynamic>;

    map.forEach((key, value) {
      final client = Client.fromMap(value);
      if (client.therapist == email)  listOfAllClients.add(client);
    });
    buildTheList(listOfAllClients);
    // notifyListeners();
  }


  void buildTheList( List<Client> clients){

    print("buildList");

    //outer Loop over the clients
    clients.forEach((client) {

      // inner loop over the sessions for each client
      client.sessions.forEach((session) {
        if (listOfClients.containsKey(DateTime(session.year,session.month, session.day, 00, 0).toLocal())) {
          // print("Value");
          //
          // print(listOfClients[DateTime(session.year, session.month, session.day, 00, 0).toLocal()]);

          //
          // listOfClients[DateTime(session.year, session.month, session.day, 00, 0).toLocal()]?.map((e) {
          //   print("name2");
          //   print(e.name.toString());
          //
          //
          // }
          // );


          if (listOfClients[DateTime(session.year, session.month, session.day, 00, 0).toLocal()]!.contains(client) == false )

            listOfClients.update(
                DateTime(session.year, session.month,
                    session.day, 00, 0).toLocal(),
                    (value) => value + [client]);

        }
        else {
            Map<DateTime, List<Client>> instance = {
              DateTime(session.year,session.month,
                  session.day , 00, 0).toLocal(): [
                client,
              ]
            };
            listOfClients.addAll(instance);
          }
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