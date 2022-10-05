import 'package:flutter/material.dart';

class Client {
  int id;
  String therapist;
  String name;
  int age;
  String caseName;
  DateTime startDate;
  List<DateTime> sessions;
  int sessionDurration;
  int price;

  Client(this.id ,
      {required this.therapist,
      required this.name,
      this.age = 0,
      required this.startDate,
      this.caseName = '',
      required this.sessions,
      this.price = 0,
      this.sessionDurration = 30});

  //serialization

Map<String, dynamic> toJson() {
  return {
    "id": id,
    "therapist": therapist,
    "name": name,
    "age": age,
    "caseName": caseName,
    "sessions": sessions,
    "startDate": startDate.millisecondsSinceEpoch,
    "sessions": sessions,
    "price": price,
    "sessionDurration": sessionDurration ,
  };
}
}

