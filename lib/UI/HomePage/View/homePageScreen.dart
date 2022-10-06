import 'package:flutter/material.dart';
import 'package:untitled/UI/HomePage/View/Component/HomePage.dart';

import '../../../utils/HelperFunctions.dart';
import '../../AddingClient/View/AddingClient.dart';
import '../../LoginPage/LoginView/Component/CenterWidgets/centerWidegt.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("El Amal Center")),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Image.asset('assets/images/facebook.png'),
        ),
        ListTile(
          title: const Text('Patients'),
          leading: const Icon(
            Icons.schedule,
            color: Colors.blueAccent,
          ),
          // trailing: Badge(
          //   badgeContent:
          //   Text("${ MyProvider.eventsCountToday ?? 0 }")
          //   ,
          //   child: null,
          // ),
          onTap: () {
            Navigator.pop(context);

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => MyHomePage(title: "Events")));
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
    );
  }
}
