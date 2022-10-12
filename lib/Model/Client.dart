import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:untitled/utils/HelperFunctions.dart';

class Patient {
  int id;
  String therapist;
  String name;
  int age;
  String caseName;
  DateTime startDate;
  DateTime storedAt;
  String storedBy;
  Map<String,List<DateTime>> sessions;
  int Durration;
  int price;
  int phone;
  String gender;

  Patient(this.id ,
      {required this.therapist,
      required this.name,
      required this.storedAt,
      required this.storedBy,
      this.age = 0,
      required this.startDate,
      this.caseName = '',
      this.gender = "male",
      required this.sessions,
      this.price = 0,
      required this.phone,
      this.Durration = 30});

  //serialization
//todo to firebase
Map<String, dynamic> toJson() {
  return {
    "id": id,
    "therapist": therapist,
    "name": name,
    "age": age,
    "caseName": caseName,
    "storedBy": storedBy,
    "storedAt": storedAt.millisecondsSinceEpoch,
    "sessions": HelperFunctions.convertList(sessions),
    "startDate": startDate.millisecondsSinceEpoch,
    "price": price,
    "Durration": Durration ,
    "phone": phone ,
    "Gender" : gender
  };
}




///from snapshot
  factory Patient.fromMap(Map<dynamic, dynamic> map) {

    //todo: from firebase

    final sessionsMap = map["sessions"] ;

    // final sessionsMap = new Map<String, dynamic>.from(map['sessions']);

    Map <String,List<DateTime>> sessionMapDT = {};

    print("toMap ${map.runtimeType}");
    print("toMap ${sessionMapDT.runtimeType}");

    List<DateTime> intToDateTime = [];

    var key = "";


    //loop over list of entry
    for ( var i = 0 ; i <= sessionsMap.length -1  ; i ++) {
      var key = sessionsMap.keys.elementAt(i);
      var listOfInt = sessionsMap[key];
      //loop over list of datetime
      for (var j = 0 ; j <= listOfInt!.length -1 ; j++){
        intToDateTime.add( DateTime.fromMillisecondsSinceEpoch(listOfInt[j]));
      }
        sessionMapDT.addAll({ key : intToDateTime});

    }


    print("toMap ${sessionMapDT["case3"].runtimeType}");

    return Patient(0,
        therapist: map["therapist"],
        name: map["name"],
        gender: map['Gender'],
        storedAt: DateTime.fromMillisecondsSinceEpoch(map["storedAt"]) ,
        storedBy:  map["storedBy"],
        startDate: DateTime.fromMillisecondsSinceEpoch(map["startDate"]),
        sessions: sessionMapDT as Map<String, List<DateTime>>,
        price:  map["price"],
        Durration:  map["Durration"],
        caseName: map["caseName"],
        age: map["age"],
        phone: map["phone"]
    );
  }
}

