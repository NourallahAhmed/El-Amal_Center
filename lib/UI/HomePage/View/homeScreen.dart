import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/UI/HomePage/View/Component/HomePage.dart';
import 'package:untitled/UI/HomePage/ViewModel/HomePageVM.dart';
import 'package:untitled/UI/LoginPage/LoginView/LoginScreen.dart';
import 'package:untitled/UI/LoginPage/ViewModel/LoginViewModel.dart';

import '../../../Services/MyProvider.dart';
import '../../../utils/HelperFunctions.dart';
import '../../AddingClient/View/AddingClient.dart';
import '../../AddingTherapist/view/AddingTherapistScreen.dart';
import '../../LoginPage/LoginView/Component/CenterWidgets/centerWidegt.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _loginVM = LoginViewModel();

  // final _homePageVM =  HomePageVM();

  @override
  initState() {}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return/* ChangeNotifierProvider(
        create: (context) => HomePageVM(),
        child: */Scaffold(
          appBar: AppBar(title: const Text("El Amal Center")),
          drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Image.asset('assets/images/facebook.png'),
            ),
            ListTile(
              title: const Text(' Add therapist'),
              leading: const Icon(
                Icons.person_add_alt,
                color: Colors.blueAccent,
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddingTherapistScreen()));
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: const Icon(
                Icons.logout,
                color: Colors.blueAccent,
              ),
              onTap: () {
                // Navigator.pop(context);
                _loginVM.logOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ])),
          body: Stack(
            children: [
              Positioned(
                top: -390,
                left: 100,
                right: -100,
                child: HelperFunctions.topWidget(screenSize.width),
              ),
              Positioned(
                bottom: -150,
                left: 90,
                child: HelperFunctions.bottomWidget(screenSize.width),
              ),
              // CenterWidget(size: screenSize),
              HomePage(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddingClientScreen()));
            },
            child: const Icon(Icons.add),
          ),
      //  )
    );

  }
}
