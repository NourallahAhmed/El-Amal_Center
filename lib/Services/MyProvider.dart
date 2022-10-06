import 'package:flutter/material.dart';

import '../Model/Client.dart';

class MyProvider with ChangeNotifier {



  static final _instance = MyProvider();

  static MyProvider getInstance() => _instance;

   late List<Client> listOfSelectedClients;

   setList(List<Client> clients) {
      listOfSelectedClients = clients;
      notifyListeners();
  }

}