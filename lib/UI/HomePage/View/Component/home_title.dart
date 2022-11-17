import 'package:flutter/material.dart';

import '../../../../utils/Shared.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            " Welcome Back\n"
                " ${SharedPref.userName} ",
            style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
