import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:untitled/presentation_layer/HomePage/View/Component/HomePage.dart';
import 'package:untitled/presentation_layer/LoginPage/LoginView/LoginScreen.dart';
import 'package:untitled/presentation_layer/LoginPage/ViewModel/LoginViewModel.dart';
import '../../../../application_layer/utils/Constants.dart';
import '../../../application_layer/utils/HelperFunctions.dart';
import '../../PatientScreens/AddingClient/View/AddingClient.dart';
import '../../TherapistScreens/AddingTherapist/view/AddingTherapistScreen.dart';
import '../../TherapistScreens/AllTherapists/view/All_Therapist_Screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  var color = Colors.lightBlue;

  @override
  initState() {}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer(builder: (context , provider , child) {
       return Scaffold(
      appBar: AppBar(

          title: const Text("El Amal Center"),
        backgroundColor: color, //<-- SEE HERE

      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color:  Constants.RBackgroundColor ,
          ),
          child: Image.asset('assets/images/hopecenter.jpg'),
        ),
        ListTile(
          title: const Text(' All therapist'),
          leading: const Icon(
            Icons.people,
            color: Colors.blueAccent,
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => All_Therapist_Screen()));
          },
        ),

        // ListTile(
        //   title: const Text(' Add therapist'),
        //   leading: const Icon(
        //     Icons.person_add_alt,
        //     color: Colors.blueAccent,
        //   ),
        //   onTap: () {
        //     Navigator.pop(context);
        //
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AddingTherapistScreen()));
        //   },
        // ),


            ListTile(
              title: const Text(' All Patients'),
              leading: const Icon(
                Icons.people,
                color: Colors.blueAccent,
              ),
              onTap: () {
                Navigator.pop(context);

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => All_Therapist_Screen()));
              },
            ),

            // ListTile(
            //   title: const Text(' Add Patient'),
            //   leading: const Icon(
            //     Icons.person_add_alt,
            //     color: Colors.blueAccent,
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => AddingClientScreen()));
            //   },
            // ),
        ListTile(
          title: const Text('Log Out'),
          leading: const Icon(
            Icons.logout,
            color: Colors.blueAccent,
          ),
          onTap: () {
            // Navigator.pop(context);
            Provider.of<LoginViewModel>(context , listen: false).logOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
spacing: 12,
        spaceBetweenChildren: 12,
        children: [
          SpeedDialChild(
            child:  Icon(Icons.add),
            label: "Patient",
            onTap: () =>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddingClientScreen()))
          ),
          SpeedDialChild(
            child:  Icon(Icons.add),
            label: "Therapist",
            onTap: () =>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddingTherapistScreen()))
          ),

        ],
      ),
      //  )
    );

    });
  }
}
