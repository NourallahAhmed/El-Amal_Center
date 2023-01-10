
import '../../application_layer/utils/HelperFunctions.dart';

class TherapistData {


  String specialization;
  String name;
  String mail;
  String password;
  DateTime startDate;
  DateTime storedAt;
  String storedBy;
  Map<String,List<DateTime>> sessions; //string name of patient
  int price;
  int phone;
  String gender;


  TherapistData(
      {required this.specialization,
        required this.name,
        required this.storedAt,
        required this.storedBy,
        required this.startDate,
        required this.mail,
        required this.password,
        this.gender = "male",
        required this.sessions,
        this.price = 0,
        required this.phone,
        });


  //TO FireBase
  Map<String, dynamic> toJson() {
    return {
      "specialization": specialization,
      "name": name,
      "storedBy": storedBy,
      "storedAt": storedAt.millisecondsSinceEpoch,
      "sessions": HelperFunctions.convertList(sessions),
      "startDate": startDate.millisecondsSinceEpoch,
      "price": price,
      "phone": phone ,
      "Gender" : gender,
      "mail" : mail,
      "password" : password,
    };
  }


  ///from snapshot
  factory TherapistData.fromMap(Map<dynamic, dynamic> map) {

    //todo: from firebase

    final sessionsMap = map["sessions"] ;

    // final sessionsMap = new Map<String, dynamic>.from(map['sessions']);

    Map <String,List<DateTime>> sessionMapDT = {};

    print(" TherapistData toMap ${map.runtimeType}");
    print(" TherapistData toMap ${sessionMapDT.runtimeType}");

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


    print("TherapistData toMap ${sessionMapDT["case3"].runtimeType}");

    return TherapistData(
       mail:  map["mail"],
       password:  map["password"],
        specialization: map["specialization"],
        name: map["name"],
        gender: map['Gender'],
        storedAt: DateTime.fromMillisecondsSinceEpoch(map["storedAt"]) ,
        storedBy:  map["storedBy"],
        startDate: DateTime.fromMillisecondsSinceEpoch(map["startDate"]),
        sessions: sessionMapDT as Map<String, List<DateTime>>,
        price:  map["price"],
        phone: map["phone"]
    );
  }
}
