import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/UI/PatientScreens/AddingClient/ViewModel/AddingClientVM.dart';
import 'package:untitled/UI/HomePage/ViewModel/HomePageVM.dart';
import 'package:untitled/UI/LoginPage/ViewModel/LoginViewModel.dart';
import 'package:untitled/utils/Shared.dart';
import 'UI/HomePage/View/home_screen.dart';
import 'UI/LoginPage/LoginView/LoginScreen.dart';
import 'UI/TherapistScreens/AddingTherapist/viewModel/AddingTherapistVM.dart';
import 'UI/TherapistScreens/AllTherapists/viewModel/All_TherapistVM.dart';
import 'utils/Constants.dart';

//receiving notifications in background from firebase
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)  async {
  print("handling a background message ${message.messageId}");
}

void main() async {
  /// for async await
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  //for push notification

  //todo if there is any background messages will be recived because of this line
  await FirebaseMessaging.instance.getInitialMessage();
  // Obtain shared preferences.
  final prefs = await SharedPref.getShared();

  final String? emailSaved =  SharedPref.isExist? SharedPref.email : null;
  final String? passwordSaved = SharedPref.isExist? SharedPref.password : null;

  //for background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
            ChangeNotifierProvider<HomePageVM>(create: (_) => HomePageVM()),
            ChangeNotifierProvider<All_TherapistVM>(create: (_) => All_TherapistVM()),
            ChangeNotifierProvider<AddingViewModel>(create: (_) => AddingViewModel()),
            ChangeNotifierProvider<AddingTherapistVM>(create: (_) => AddingTherapistVM()),
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
      scaffoldBackgroundColor: Constants.kBackgroundColor,

      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: Constants.kPrimaryColor,
        fontFamily: 'Montserrat',
      ),
      ),
      home:
          this.email != null && this.pass != null ? const HomePageScreen() : const LoginScreen(),
    );
  }
}

