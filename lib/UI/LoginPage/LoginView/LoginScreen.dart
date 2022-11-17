

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/UI/LoginPage/ViewModel/LoginViewModel.dart';

import 'Component/CenterWidgets/centerWidegt.dart';
import 'Component/LoginContent.dart';
import '../../../utils/HelperFunctions.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
   return Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -160,
              left: -30,
              child: HelperFunctions.topWidget(screenSize.width),
            ),
            Positioned(
              bottom: -180,
              left: -40,
              child: HelperFunctions.bottomWidget(screenSize.width),
            ),
            CenterWidget(size: screenSize),
            const Login_Content(),
          ],
        ),
    );

  }
}