
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Model/Client.dart';
import 'package:untitled/Services/MyProvider.dart';

class HomePageVM{
  //todo fetch the data related to the therpist by email
  final List<Client> _listOfAllClients = [];
  final List<Client> _listOfTodaysClients = [];



  Future<void> fetchAllData() async {
    print("Fetch All Data");
    var shared = await SharedPreferences.getInstance();

    var email = shared.get("email");
    final snapshot = await FirebaseDatabase.instance.ref('Client/').get();
    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      final client = Client.fromMap(value);

      if (client.therapist == email){
        _listOfAllClients.add(client);

      }
    });

    print(_listOfAllClients);

    MyProvider.getInstance().setList(_listOfAllClients);
  }


  getClientsList() => _listOfAllClients;


  String? getCurrentUser() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email.toString().substring(0,user.email?.lastIndexOf("@")) : null;
  }


}