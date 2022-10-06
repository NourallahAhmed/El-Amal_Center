import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class AddingViewModel{

  FirebaseAuth _Firebase =  FirebaseAuth.instance;

  FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference _ref = FirebaseDatabase.instance.ref();

  List<String> therapists  = [];
  
  //todo write a new therapist >> will be from login <<
  
  Future<void> getAllTherapist()  async {
    final url = Uri.parse("https://alamalcenter-57cdf-default-rtdb.firebaseio.com/Therapist");


    try {
      final http.Response reposne = await http.get(url);
      final jsonbody = json.decode(reposne.body);

      print(jsonbody["name"]);
      print(json.decode(reposne.body));
    }catch(e){
      print(e);
    }
    // final snapshot = await _ref.child('Therapist/').get();
    // if (snapshot.exists) {
    //   snapshot.children.map((e) => print("email ${e}") );//therapists.add(e.value.toString()));
    //
    //
    //
    //
    //
    //  print(therapists);
    // } else {
    //   print('No data available.');
    // }
  }
  
  //todo get all employees from firebase

  // Future<void> getAllTherapist() async {
  //
  // }
}