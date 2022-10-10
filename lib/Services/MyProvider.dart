import 'package:flutter/material.dart';

import '../Model/Client.dart';

class MyProvider with ChangeNotifier {



  static final _instance = MyProvider();

  static MyProvider getInstance() => _instance;

   late List<Patient> listOfSelectedClients;

   setList(List<Patient> clients) {
      listOfSelectedClients = clients;
      notifyListeners();
  }

}