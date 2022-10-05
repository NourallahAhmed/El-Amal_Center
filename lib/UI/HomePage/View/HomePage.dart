import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../Model/Client.dart';
import '../../AddingClient/View/AddingClient.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key , required String? this.email}) : super(key: key);
  String? email;

  @override
  State<HomePage> createState() => _HomePageState(this.email);


}

class _HomePageState extends State<HomePage> {

  String? email;


  DateTime selectedDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);

  DateTime _focusedDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);



  late List<Client> selectedList;


  Map<DateTime, List<Client>>? Client_List;



  _HomePageState(this.email);



  //todo handle Selection

  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedList = Client_List?[selectedDay.toUtc()] ?? [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("My Todo List"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.blueAccent.withOpacity(0.1),
                  Colors.white,
                ],
                stops: const [
                  0.0,
                  1.0
                ])
          // color: Colors.blue.shade200
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "My Todo List      ",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                RotationTransition(
                  turns: const AlwaysStoppedAnimation(15 / 360),
                  child: Image.network(
                    "https://ouch-cdn2.icons8.com/BbYaGQcG9qxVp4LAoSXm-fhbsTutCLjWaV2ESMk6GMI/rs:fit:256:171/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMy82/YTk5NTJiMi1mNWVh/LTRkNDAtYjZlMi1h/ZGQzODUwYTIwMjUu/c3Zn.png",
                    height: 70,
                    width: 90,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 150,
            child: TableCalendar(
              shouldFillViewport: true,
              calendarFormat: CalendarFormat.week,
              firstDay: DateTime(2020),
              lastDay: DateTime(2025),
              focusedDay: _focusedDay,
              currentDay: _focusedDay,
              onDaySelected: (date, focusedDay) {
                setState(() {
                  selectedDay = date;
                  print(date);
                  _handleData(selectedDay.toUtc());
                  _focusedDay =
                      date; // update `_focusedDay` here as well
                });
              },
            ),
          ),

          Expanded(
            child: selectedList.isNotEmpty
                ? ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int index) {
                final Client client = selectedList[index];
                // final String start = DateFormat('HH:mm:aa')
                //     .format(client.sessions)
                //     .toString();

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
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddingClient()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
