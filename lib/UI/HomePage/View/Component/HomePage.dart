import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/UI/HomePage/ViewModel/HomePageVM.dart';

import '../../../../Model/Client.dart';
import '../../../AddingClient/View/AddingClient.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {




  DateTime selectedDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);

  DateTime _focusedDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);




  var homeVM = HomePageVM();


  late List<Client> selectedList;


  Map<DateTime, List<Client>>? Client_List;



  _HomePageState();



  //todo handle Selection

  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedList = Client_List?[selectedDay.toUtc()] ?? [];
    });
  }

@override
  initState(){

    selectedList = [];
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Welcome
      Container(
        margin: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Text(
              " Welcome Back\n"
                  " ${homeVM.getCurrentUser()} ",
              style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),


      //Calender
      SizedBox(
        height: 150,
        child: TableCalendar(
          shouldFillViewport: true,
          calendarFormat: CalendarFormat.week,
          firstDay: DateTime(DateTime.now().year),
          lastDay: DateTime(DateTime.now().year + 25),
          focusedDay: _focusedDay,
          currentDay: DateTime.now(),
          onDaySelected: (date, focusedDay) {
            setState(() {
              _handleData(selectedDay.toUtc());
              _focusedDay =
                  date; // update `_focusedDay` here as well
            });
          },
        ),
      ),



      //List of Patients

      Expanded(
        child: selectedList.isNotEmpty
            ? ListView.builder(
          padding: const EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            final Client client = selectedList[index];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\t \t \t  ${index + 1}  \t \t \t ${client.name}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ],
            );
          },
          itemCount: selectedList.length,
        )

            : Center(
          child: Image.network("https://ouch-cdn2.icons8.com/BbYaGQcG9qxVp4LAoSXm-fhbsTutCLjWaV2ESMk6GMI/rs:fit:256:171/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMy82/YTk5NTJiMi1mNWVh/LTRkNDAtYjZlMi1h/ZGQzODUwYTIwMjUu/c3Zn.png"),
        ),
      ),
    ]);
  }
}
