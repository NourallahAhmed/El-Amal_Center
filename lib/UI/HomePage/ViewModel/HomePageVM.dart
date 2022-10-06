import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Model/Client.dart';

class HomePageVM{
  //todo fetch the data related to the therpist by email

  // Future<List<Client>> fetchAllData(String email) async {
  //
  //
  //
  // }




 String? getCurrentUser() {
    var user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email.toString().substring(0,user.email?.lastIndexOf("@")) : null;
  }

}