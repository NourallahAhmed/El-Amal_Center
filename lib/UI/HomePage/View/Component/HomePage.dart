import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/UI/HomePage/ViewModel/HomePageVM.dart';
import 'package:untitled/utils/Shared.dart';
import '../../../../Model/Client.dart';
import '../../../../Services/PushNotifictionServices.dart';
import '../../../../utils/Constants.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {

  DateTime selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);

  var homeVM = HomePageVM();

  late List<Patient> selectedList;

  Map<DateTime, List<Patient>>? client_List;

  //todo handle Selection
  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedList = client_List?[date] ?? [];
      print(selectedList);
    });
  }

@override
  initState(){

    //todo be in initState in home page
    PNServices.requestPermission();
    PNServices.getToken(SharedPref.email);
    PNServices.initInfo();
    print("initState()");
      homeVM.fetchAllData();
      selectedList = homeVM.listOfAllClients;
      client_List = homeVM.listOfClients;
      // selectedList = client_List?[_focusedDay] ??[];
      // _handleData(_focusedDay);
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
            _handleData(DateTime(
                date.year,date.month, date.day, 00, 0).toLocal());
            selectedDay = date;
            _focusedDay =
                date; // update `_focusedDay` here as well
          });
        },
      ),
    );
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

  Widget clientRow(Patient client) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "${client.name}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: kSecondaryColor),
                ),

                Text(
                  "${client.caseName}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: kSecondaryColor),
                ),
                Text(
                  "Therapist: ${client.therapist.substring(0,client.therapist.lastIndexOf("@"))}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: kSecondaryColor),
                ),
                Text(
                  "Durration: ${client.Durration} min",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: kSecondaryColor),
                ),


              ],
            ),

            const SizedBox(width: 20,),


          //MARK: passing only the list of time
          sessionsView(client.sessions) ,


           /* Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_active_outlined)),
              ],
            )*/
          ],
        ),
      ),
    );
  }

  Widget sessionsView( Map<String, List<DateTime> > sessionsMap) {
    print("from sessions View");

    print("from sessions View  ${sessionsMap.values.last}" );

    var sessionsOfTheDay = [];

    var sessions = sessionsMap.values.last as List<DateTime>;

    print("from sessions View");

    print(sessions);

    List<Widget> customRow = [];
    sessions.forEach((session) {
        // print("loop");
        // print(session.toLocal());
        // print(selectedDay);
      if (session.day == selectedDay.day){
        // sessionsOfTheDay.add(session);
        var  time =  DateFormat('HH:mm:aa').format(session).toString();
        customRow.add(
               // const Icon(Icons.alarm),
               // const SizedBox(width: 15,),
               Text("${time}" , style: TextStyle(fontSize: 15),),
        );
      }
    });

    return Column(
      children: customRow
    );
  }
  Widget homeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context, int index) {
        final Patient client = selectedList[index];

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





  @override
  Widget build(BuildContext context) {
    return
      Consumer<HomePageVM>(builder: (context, provider, child) {
        return
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
     });
  }


}
