import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/Client.dart';
import '../../../Services/PushNotifictionServices.dart';
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
        therapists.add(name);
        // therapists.add(name.substring(0, name.lastIndexOf("@")));
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

  Future<void> addClient(Patient patient) async{

      print("addClient");
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("Client/");

    //Store the email in the RealTimeDB
    await _databaseReference.push().set(
        patient.toJson()
    ).onError((error, stackTrace) =>
    print("Error will set patient ${error}  stackTrace = ${stackTrace}"));
    sendNotifiction(patient);


    print("addClient");
  }


  sendNotifiction(Patient p) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("Tokens")
        .doc(p.therapist)
        .get();


    String token = snap['token'];


    print('token from login = ${token}');

    PNServices.sendPushMessage(token, """
    Check the new session for ${
    p.name
    }
    """, "Al Amal Center");
  }
  getUserName() =>  SharedPref.userName;

}