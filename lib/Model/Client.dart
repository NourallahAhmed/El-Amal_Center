import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Client {
  int id;
  String therapist;
  String name;
  int age;
  String caseName;
  DateTime startDate;
  DateTime storedAt;
  String storedBy;
  // List<DateTime> sessions;
  int Durration;
  int price;
  String gender;

  Client(this.id ,
      {required this.therapist,
      required this.name,
      required this.storedAt,
      required this.storedBy,
      this.age = 0,
      required this.startDate,
      this.caseName = '',
      this.gender = "male",
        // this.sessions = [],
      this.price = 0,
      this.Durration = 30});

  //serialization

Map<String, dynamic> toJson() {
  return {
    "id": id,
    "therapist": therapist,
    "name": name,
    "age": age,
    "caseName": caseName,
    "storedBy": storedBy,
    "storedAt": storedAt,
    // "sessions": sessions,
    "startDate": startDate.millisecondsSinceEpoch,
    "price": price,
    "Durration": Durration ,
    "Gender" : gender
  };
}

///from snapshot


  factory Client.fromMap(Map<dynamic, dynamic> map) {
    return Client(0,
        therapist: map["Therapist"],
        name: map["name"],
        gender: map['Gender'],
        storedAt: DateTime.fromMillisecondsSinceEpoch(map["storedAt"]) ,
        storedBy:  map["storedBy"],
        startDate: DateTime.fromMillisecondsSinceEpoch(map["startDay"]),
        // sessions:  map["SesionDays"] as Map,
        price:  map["price"],
        Durration:  map["Durration"],
        caseName: map["Case"],
        age: map["Age"],
    );
  }
}

