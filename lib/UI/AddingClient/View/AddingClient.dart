import 'package:flutter/material.dart';
import 'package:untitled/UI/AddingClient/View/Component/AddingClientPages.dart';

import '../../../utils/HelperFunctions.dart';

class AddingClientScreen extends StatefulWidget {
  const AddingClientScreen({Key? key}) : super(key: key);

  @override
  State<AddingClientScreen> createState() => _AddingClientScreenState();
}

class _AddingClientScreenState extends State<AddingClientScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar:  AppBar(
          title:  Text("El Amal Center"),
      ),
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
          AddingClientPages(),
        ],
      )
    );

  }
}
