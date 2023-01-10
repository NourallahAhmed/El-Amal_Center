import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../presentation_layer/HomePage/View/Component/client_row.dart';
import '../../../../presentation_layer/HomePage/View/Component/home_title.dart';
import '../../../../presentation_layer/HomePage/ViewModel/HomePageVM.dart';
import '../../../../application_layer/utils/Shared.dart';
import '../../../../domain_layer/Model/Client.dart';
import '../../../../data_layer/data_source/Services/PushNotifictionServices.dart';


import 'empty_list.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {

  DateTime selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 0);

  late List<Patient> selectedList;

  Map<DateTime, List<Patient>>? selectedDaysClients;

  Map<String, List<DateTime>>? clients;

  //todo handle Selection
  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedList = selectedDaysClients?[date] ?? [];
    });
  }

  @override
  initState(){

    //todo be in initState in home page
    PNServices.requestPermission();

    PNServices.getToken(SharedPref.email);


    PNServices.initInfo();



      print("initState()");
     Provider.of<HomePageVM>(context , listen:  false).fetchAllData();
     Provider.of<HomePageVM>(context , listen:  false).fetchSpecificTherapist();


      //MARK if the user is the admain and want to show all the client as well
      selectedList = Provider.of<HomePageVM>(context , listen:  false).listOfAllClients.cast();
      selectedDaysClients = Provider.of<HomePageVM>(context , listen:  false).listOfClients.cast<DateTime, List<Patient>>();

      _handleData(_focusedDay);

      clients = Provider.of<HomePageVM>(context , listen:  false).listOfTherapistClients;

  }

  Widget homeCalender(){
    return

      SizedBox(
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

  Widget homeList(HomePageVM provider) {
    return ListView.builder(

      padding: const EdgeInsets.all(0.0),

      itemBuilder: (BuildContext context, int index) {

        final Patient patient = selectedList[index];

        return ClientRow(patient: patient, selectedDay : selectedDay ); //todo index will indicate the index of list of date time in the map

      },

      itemCount: selectedList.length,
    );

  }

  @override
  Widget build(BuildContext context) {
    return
      Consumer<HomePageVM>(builder: (context, provider, child) {
        return
          Column(children: [
            //Welcome
            const HomeTitle(),

            //Calender
            homeCalender(),

            //List of Patients
            Expanded(
              child: selectedList.isNotEmpty
                  ? homeList(provider)
                  : EmptyList()
            ),
          ]);
     });
  }


}
