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
  List<DateTime> sessions;
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
        required this.sessions,
      this.price = 0,
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
    "sessions": convertList(sessions),
    "startDate": startDate.millisecondsSinceEpoch,
    "price": price,
    "Durration": Durration ,
    "Gender" : gender
  };
}

//todo  convert list of sessions to map to firebase
Map<int, int> convertList(List<DateTime> list) {
    Map<int, int>  map = {};

    list.forEach((element) {
    var newMap =
      {list.indexOf(element) :
        element.millisecondsSinceEpoch
      };

    map.addEntries(newMap.entries);
  });


  return map;
  }

///from snapshot

  factory Client.fromMap(Map<dynamic, dynamic> map) {

  //todo: from firebase
    final List<int> sessionsMap = map["sessions"].cast<int>() ;
    final List<DateTime> sessionList  = [];
    sessionsMap.forEach(( value) => sessionList.add(DateTime.fromMillisecondsSinceEpoch(value)));

    print(map["therapist"]);
    return Client(0,
        therapist: map["therapist"],
        name: map["name"],
        gender: map['Gender'],
        storedAt: DateTime.fromMillisecondsSinceEpoch(map["storedAt"]) ,
        storedBy:  map["storedBy"],
        startDate: DateTime.fromMillisecondsSinceEpoch(map["startDate"]),
        sessions: sessionList,
        price:  map["price"],
        Durration:  map["Durration"],
        caseName: map["caseName"],
        age: map["age"],
    );
  }
}

