import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionViews extends StatelessWidget {
  Map<String,List<DateTime>> sessionsMap;
  DateTime selectedDay;
  var sessionsOfTheDay = [];


  SessionViews({Key? key , required this.sessionsMap , required this.selectedDay}) : super(key: key);



  @override
  Widget build(BuildContext context) {


    var sessions = sessionsMap.values.last;

    print("from sessions View");

    print(sessions);

    List<Widget> customRow = [];
    sessions.forEach((session) {
      if (session.day == selectedDay.day){
        // sessionsOfTheDay.add(session);
        var  time =  DateFormat('HH:mm:aa').format(session).toString();
        customRow.add(
          Text("${time}" , style: TextStyle(fontSize: 15),),
        );
      }
    });
    return Column(
        children: customRow
    );
  }
}
