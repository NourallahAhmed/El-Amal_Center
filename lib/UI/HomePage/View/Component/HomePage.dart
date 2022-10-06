import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/UI/HomePage/ViewModel/HomePageVM.dart';
import '../../../../Model/Client.dart';
import '../../../../utils/Constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {

  DateTime selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);

  var homeVM = HomePageVM();

  late List<Client> selectedList;

  Map<DateTime, List<Client>>? Client_List;

  //todo handle Selection
  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedList = Client_List?[selectedDay.toUtc()] ?? [];
    });
  }

@override
  initState(){


    print("initState()");
     homeVM.fetchAllData();
    setState((){
      selectedList = homeVM.getClientsList();

    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // selectedList = Provider.of<MyProvider>(context).listOfSelectedClients;
  }

  Widget titleOfPage(){
  return  Container(
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
    );
  }

  Widget clientRow(Client client) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(

        elevation: 8,
        shadowColor: Colors.black87,
        color: RBackgroundColor,
        borderRadius: BorderRadius.circular(30),
        child: Row(

          children: [
            SizedBox(
              width: 90,
              height: 90,
              child:    client.gender == "male" ? Image.asset('assets/images/man.png') : Image.asset('assets/images/woman.png')  ,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  " ${client.name}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: kSecondaryColor),
                ),

                Text(
                  "Case: ${client.caseName}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                Text(
                  "Age: ${client.age}",
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                Text(
                  "Durration: ${client.Durration} min",
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                
              
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_active_outlined)),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget homeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context, int index) {
        final Client client = selectedList[index];

        return clientRow(client);
      },
      itemCount: selectedList.length,
    );

  }

  Widget emptyList(){
    return Center(
      child: Image.network(
          "https://ouch-cdn2.icons8.com/BbYaGQcG9qxVp4LAoSXm-fhbsTutCLjWaV2ESMk6GMI/rs:fit:256:171/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMy82/YTk5NTJiMi1mNWVh/LTRkNDAtYjZlMi1h/ZGQzODUwYTIwMjUu/c3Zn.png"),
    );
  }

  Widget homeCalender(){
    return SizedBox(
      height: 150,
      child: TableCalendar(
        shouldFillViewport: true,
        calendarFormat: CalendarFormat.week,
        firstDay: DateTime(DateTime
            .now()
            .year),
        lastDay: DateTime(DateTime
            .now()
            .year + 25),
        focusedDay: _focusedDay,
        currentDay: selectedDay,
        onDaySelected: (date, focusedDay) {
          setState(() {
            _handleData(selectedDay.toUtc());
            selectedDay = date;
            _focusedDay =
                date; // update `_focusedDay` here as well
          });
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return
      // Consumer<MyProvider>(builder: (context, provider, child) {
      //   return
          Column(children: [
            //Welcome
            titleOfPage(),

            //Calender
            homeCalender(),

            //List of Patients
            Expanded(
              child: selectedList.isNotEmpty
                  ? homeList()
                  : emptyList()
            ),
          ]);
   //   });
  }


}