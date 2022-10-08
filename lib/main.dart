import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Services/MyProvider.dart';
import 'package:untitled/UI/AddingClient/ViewModel/AddingClientVM.dart';
import 'package:untitled/UI/HomePage/ViewModel/HomePageVM.dart';
import 'package:untitled/UI/LoginPage/ViewModel/LoginViewModel.dart';
import 'package:untitled/utils/Shared.dart';

import 'UI/HomePage/View/Component/HomePage.dart';
import 'UI/HomePage/View/homeScreen.dart';
import 'UI/LoginPage/LoginView/LoginScreen.dart';
import 'utils/Constants.dart';

void main() async {
  /// for async await
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  // var _ref = FirebaseDataBase();



  // Obtain shared preferences.
  final prefs = await SharedPref.getShared();

  final String? emailSaved =  SharedPref.isExist? SharedPref.email : null;
  final String? passwordSaved = SharedPref.isExist? SharedPref.password : null;


  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
            ChangeNotifierProvider<HomePageVM>(create: (_) => HomePageVM()),
            ChangeNotifierProvider<AddingViewModel>(create: (_) => AddingViewModel()),
          ],
          child: MyApp(email: emailSaved, pass: passwordSaved))
      );

}

class MyApp extends StatelessWidget {
   MyApp({Key? key , required String? this.email , required String? this.pass}) : super(key: key);

   String? email;
   String? pass;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    print("emailSaved ${email}" );
    print("todays date ${DateTime(2022,10,6).millisecondsSinceEpoch}" );
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(
      scaffoldBackgroundColor: kBackgroundColor,

      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: kPrimaryColor,
        fontFamily: 'Montserrat',
      ),
      ),
      home:
          this.email != null && this.pass != null ? const HomePageScreen() : const LoginScreen(),
    );
  }
}

