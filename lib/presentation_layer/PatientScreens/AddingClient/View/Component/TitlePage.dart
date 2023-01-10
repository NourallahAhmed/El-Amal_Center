import 'package:flutter/material.dart';

import '../../../../../application_layer/utils/Constants.dart';

class TitlePage extends StatelessWidget {
  TitlePage({
    Key? key, required String this.title , IconData? this.icon
  }) : super(key: key);

  String title ;
  IconData? icon ;
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin:  EdgeInsets.all(8.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text(
            title,
            style:   TextStyle(
                color: Constants.kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10,),
          icon != null ? Icon(  icon , color: Constants.kPrimaryColor, size: 50,) : Container() ,

        ],
      ),
    );
  }
}