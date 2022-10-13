import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {


  static late SharedPreferences pref;
  static late String email ;
  static late String userName;
  static late String password;
  static var isExist = false;
  static  Future<SharedPreferences> getShared () async{

    pref = await SharedPreferences.getInstance();
    if (pref.containsKey("email")){
      isExist = true;
      email = (await pref.getString("email"))!;
      userName = email.substring(0,email.indexOf("@"));
      password = (await pref.getString("password")) ?? "";

    }
    return pref;
  }


}