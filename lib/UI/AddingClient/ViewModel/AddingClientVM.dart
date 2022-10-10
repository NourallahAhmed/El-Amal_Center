import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/Client.dart';
import '../../../utils/Shared.dart';

class AddingViewModel  with ChangeNotifier{

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
    print("After fetching ${therapists}");
    notifyListeners();
    print("notified");
  }

  List<String> getListOfTherapist() => therapists;

  Future<void> addClient(Patient Patient) async{
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Client/");

    //Store the email in the RealTimeDB
    await _databaseReference.push().set(
        Patient.toJson()
    );
    print("addClient");
  }

  getUserName() =>  SharedPref.userName;

}