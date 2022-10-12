import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/UI/PatientScreens/AddingClient/View/Component/AddingClientPages.dart';
import 'package:untitled/UI/PatientScreens/AddingClient/ViewModel/AddingClientVM.dart';

import '../../../../utils/HelperFunctions.dart';

class AddingClientScreen extends StatefulWidget {
  const AddingClientScreen({Key? key}) : super(key: key);

  @override
  State<AddingClientScreen> createState() => _AddingClientScreenState();
}

class _AddingClientScreenState extends State<AddingClientScreen> {



  @override
  Widget build(BuildContext context) {

    print(DateTime.now().millisecondsSinceEpoch);
    final screenSize = MediaQuery
        .of(context)
        .size;

    return /*ChangeNotifierProvider(
        create: (context) => AddingViewModel(),
    child:
*/
      Scaffold(
      appBar:  AppBar(
          title:  Text("El Amal Center"),
      ),
      body: Stack(
        children: const [
          // Positioned(
          //   top: -390,
          //   left: 100,
          //   right: -100,
          //   child: HelperFunctions.topWidget(screenSize.width),
          // ),
          // Positioned(
          //   bottom: -150,
          //   left: 90,
          //   child: HelperFunctions.bottomWidget(screenSize.width),
          // ),
          // // CenterWidget(size: screenSize),
           AddingClientPages(),
        ],
      )
    );
    // );

  }
}
