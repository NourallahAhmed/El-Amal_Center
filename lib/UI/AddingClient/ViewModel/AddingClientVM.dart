import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import '../../../Model/Client.dart';

class AddingViewModel {

  FirebaseAuth _Firebase = FirebaseAuth.instance;

  DatabaseReference _ref = FirebaseDatabase.instance.ref();

  List<String> therapists = [];

  //todo write a new therapist >> will be from login <<

  //todo get all employees from firebase
  Future<void> getAllTherapist() async {
    print("getAllTherapist");
    final snapshot = await _ref.child('Therapist').get();
    if (snapshot.exists) {
      Map therapist = snapshot.value as Map;

      for (var el in therapist.values) {
        var name = el['name'].toString();
        therapists.add(name.substring(0, name.lastIndexOf("@")));
      }
    }
    else {
      print('No data available.');
    }
  }

  List<String> getListOfTherapist() => therapists;

  Future<void> addClient(Client client) async{
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Client/");

    //Store the email in the RealTimeDB
    await _databaseReference.push().set(
        client.toJson()
    );
    print("addClient");
  }
}