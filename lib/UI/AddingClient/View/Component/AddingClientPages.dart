import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:untitled/UI/AddingClient/View/Component/InputFeild.dart';
import 'package:untitled/UI/HomePage/ViewModel/HomePageVM.dart';
import 'package:untitled/utils/Shared.dart';
import 'package:untitled/utils/extensions.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/intl.dart';
import '../../../../Model/Client.dart';
import '../../../HomePage/View/homeScreen.dart';
import '../../ViewModel/AddingClientVM.dart';
import '../../View/Component/TitlePage.dart';
import '../../../../utils/Constants.dart';

class AddingClientPages extends StatefulWidget {
  const AddingClientPages({Key? key}) : super(key: key);

  @override
  State<AddingClientPages> createState() => _AddingClientPagesState();
}

class _AddingClientPagesState extends State<AddingClientPages> {

  var _addingVM = AddingViewModel();

  var items = ["case1" , "case2" , "case3"]; //todo will be enum by the actual names

  late List<String> _listOftherapist ;
  String _clientCase = "case1";
  String _clientTherapist  = SharedPref.email;
  List<DateTime> _listOfSelectedTime = [];
  final _clientNameController = TextEditingController();
  final _clientAgeController = TextEditingController();
  final _clientPriceController = TextEditingController();
  final _clientDurrationController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  var list = <Widget>[];
  DateTime? selectedTime = DateTime.now();
  Gender? _clientGender;

  Widget caseDropDownList(List<dynamic> items){

    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton(
            isExpanded:true,
            borderRadius: BorderRadius.circular(30),
            hint: const Text("Case"),
            value: _clientCase,
            items:
              items.map((items) {
                return DropdownMenuItem(
                  value: items,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(items , style: TextStyle( fontSize: 17),),
                  ),
                );
              }).toList(),
          onChanged: (value){
            setState((){
              this._clientCase = value.toString();
            });
          }
        )
    // ),
      );
  }

  Widget therapistDropDownList(List<dynamic> items ){
      // _clientTherapist =  items.isNotEmpty ? items[0] : "";

    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton(
            alignment : AlignmentDirectional.center,
            isExpanded:true,
             borderRadius: BorderRadius.circular(20),
            hint: const Text("Therapist"),
            value: _clientTherapist,
            items:
              items.map((items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items , style:  TextStyle(color: kPrimaryColor  , fontSize: 17,),),
                );
              }).toList(),

          onChanged: (value){
              setState((){
                _clientTherapist = value  as String;
              });
          }
          ),
      // )
      );
  }

  Widget _listOfSelectedTimeWidget() {
    var List =  <Widget> [];
    for(var i = 0 ; i < _listOfSelectedTime.length ; i++){
     List.add( Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  //editing selected time
                    onTap: () async {
                      var prevSelection = _listOfSelectedTime.elementAt(i);

                      var time = await pickTime(prevSelection) as TimeOfDay;

                      _listOfSelectedTime.removeAt(_listOfSelectedTime.indexOf(prevSelection));

                      var firstOfMonth = DateTime(prevSelection.year, prevSelection.month, prevSelection.weekday , time.hour , time.minute);


                      var firstDayPickedInMonth = firstOfMonth.addCalendarDays((7 - (firstOfMonth.weekday -  prevSelection.weekday)) % 7);


                      setState((){

                        handleTimeSelection(firstDayPickedInMonth);

                      });
                    },
                    child: Text(" ${DateFormat('EE HH:mm:aa').format(_listOfSelectedTime.elementAt(i)).toString()}"))
            ),

            IconButton(onPressed: (){

              //deleting Selected time
              setState((){

               _listOfSelectedTime.removeAt(i);
               print(_listOfSelectedTime);
             });


            }, icon: Icon(Icons.dangerous )),
          ],
        ),
     ));
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List,
    );
  }



  Widget _GenderButtons(Gender gender){
    return
      Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(

              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border:  Border.all(color: RBackgroundColor)
            ),
            child:
            GestureDetector(
              child:  Row(
                children: [


                  Text("${gender.name}"),
                   gender.name == 'Female' ?  Icon(Icons.female) :    Icon(Icons.male),

                ],
              ),
                onTap: (){
                  _clientGender = gender;
                        print(_clientGender);
                },
            )

          ),
        );
  }

  @override
  initState(){

    _addingVM.getAllTherapist();
    _listOftherapist = _addingVM.therapists;
      // _clientTherapist = _addingVM.therapists.first;
  }

  
  @override
  Widget build(BuildContext context) {
    print("from build");

    print( _listOftherapist.isNotEmpty);
    print( _listOftherapist);
    List<bool> values = List.filled(7, false);
    return Consumer<AddingViewModel>(builder: (context, provider, child) {
      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitlePage(title: " New Patient ", icon : Icons.person_add_alt ),

            SizedBox(width: 30, height: 40,),
            //Name of the client
            InputFeild(hint: "Yasser", iconData: Icons.person, txtController: _clientNameController, keyType: TextInputType.name, label: "Name"),

            //Age of the Client
            InputFeild(hint: "12", iconData: Icons.person, txtController: _clientAgeController, keyType: TextInputType.number, label: "Age"),

            SizedBox(width: 30, height: 20,),


            //todo Gender session
          const  Text("\t \tGender: \t" ,style: TextStyle(color: kPrimaryColor , fontSize: 17),),

            SizedBox(width: 30, height: 10,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              _GenderButtons(_clientGender = Gender.Female),
              _GenderButtons(_clientGender = Gender.Male),
            ],
          ),
            SizedBox(width: 30, height: 20,),

            //phone Number
            InputFeild(hint: "012222222222", iconData: Icons.phone_android, txtController: _clientPhoneController, keyType: TextInputType.phone, label: "Phone Number"),
            //Price
            InputFeild(hint: "120", iconData: Icons.money, txtController: _clientPriceController, keyType: TextInputType.number, label: "Price"),

            //Duration
            InputFeild(hint: "30", iconData: Icons.timer, txtController: _clientDurrationController, keyType: TextInputType.number, label: "Durration in MIN"),

            const SizedBox(
              height: 15,
            ),

            //Sessions
            // case and therapist
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "\t Client`s case:",
                        style: TextStyle(color: kPrimaryColor, fontSize: 17),
                      ),
                      //Case of the Client
                      caseDropDownList(items),

                      const  Text("\t Sessions Schedule" ,style: TextStyle(color: kPrimaryColor , fontSize: 17),),


                      WeekdaySelector(
                        firstDayOfWeek: 7,
                        selectedElevation: 30,
                        color :kPrimaryColor ,
                        onChanged: (val) async {

                          var now = DateTime.now();
                          var time = await pickTime(now) as TimeOfDay;

                          setState((){

                            var now = DateTime.now();

                            var firstOfMonth = DateTime(now.year, now.month, val , time.hour , time.minute);

                            var firstDayPickedInMonth = firstOfMonth.addCalendarDays((7 - (firstOfMonth.weekday - val)) % 7);

                            handleTimeSelection(firstDayPickedInMonth);


                            print(_listOfSelectedTime);
                          });
                        },
                        values: values,
                      ),

                    _listOfSelectedTime.isNotEmpty ?
                      _listOfSelectedTimeWidget() : Container(),


                      const  Text(
                        "\t Client`s therapist:",
                        style: TextStyle(color: kPrimaryColor, fontSize: 17),
                      ),

                      //todo: therapist
                       _listOftherapist.isNotEmpty
                          ? therapistDropDownList(_listOftherapist)
                          : Container(),
                    ],
                  )),

            SizedBox(
              height: 50,
            ),

            ///AddingButton



            Center(
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  shape: const StadiumBorder(),
                  primary: Colors.white,
                  elevation: 18,
                  shadowColor: Colors.black87,
                  // maximumSize: Size.fromWidth(500)
                ),
                child: const Text(
                  "\t Add Patient \t",
                  style:  TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: (){

                   print("from adding page the selected time list == ${_listOfSelectedTime}");


                    var sessionList = prepareSessionList(_listOfSelectedTime);

                    print("from adding page the session list == ${sessionList}");
                    var client =
                    Patient(0,
                      name : _clientNameController.text,
                      age : int.parse(_clientAgeController.text),
                      therapist: _clientTherapist,
                      caseName: _clientCase,
                      startDate: DateTime.now(),
                      storedAt: DateTime.now(),
                      storedBy: SharedPref.email,
                      sessions : sessionList,
                        Durration : int.parse(_clientDurrationController.text),
                      price: int.parse(_clientPriceController.text),
                      phone: int.parse(_clientPhoneController.text),
                      gender: "male"
                    );

                    _addingVM.addClient(client);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageScreen()));

                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ],
        ),
      ),
    );
  });
  }


   Future<TimeOfDay?> pickTime(DateTime now) => showTimePicker(context: context, initialTime: TimeOfDay(hour: now.hour, minute: now.minute));
   Future<DateTime?> pickDate() => showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year + 25));
   Future<DateTime?> showDateTimePicker() async {
   DateTime? date = await pickDate();
   if (date != null ) {
     TimeOfDay? time = await pickTime(DateTime.now());
     if (time != null){
        final dateTime = DateTime(date.year,date.month,date.year,time.hour, time.minute);
        return dateTime;
     }
   }
 }

  handleTimeSelection(DateTime firstDayPickedInMonth){

    print(firstDayPickedInMonth);
    //todo check the firstday if it less than current do not add it
    if (firstDayPickedInMonth.day < DateTime.now().day){
      var nextDayInMonth = firstDayPickedInMonth.addCalendarDays(1 * 7);
      _listOfSelectedTime.add(firstDayPickedInMonth.addCalendarDays(1 * 7));
      print("after adding ${_listOfSelectedTime}");
      // do not add it
      print("firstDayPickedInMonth.day = ${firstDayPickedInMonth.day}" );
      print("DateTime.now().day = ${DateTime.now().day}" );
      print("nextDayInMonth = ${nextDayInMonth}" );

    }
    else{

      _listOfSelectedTime.add(firstDayPickedInMonth);
    }

  }


  List<DateTime> prepareSessionList(List<DateTime> selectedTimes){

     print("from prepareSessionList the upcomming list == ${selectedTimes}");

     List<DateTime>  sessionList = [];
    //todo handle schedule for 2 month = 8 week == 8 loops

     selectedTimes.forEach((e){
       print("inside the map ${e}");

      for (var week = 1 ; week <= 9 ; week ++){
        print("inside the for loop  ${e}");
        sessionList.add(e.addCalendarDays(week * 7));
        print("after adding ");
        print("the list = ${sessionList}");

      }

      // for (var week = 1 ; week <= 9 ; week ++){
      //
      //   _listOfSessionsTime.add(e.addCalendarDays(week * 7));
      // }

    });


     print("from prepareSessionList the returned list sessionList == ${sessionList}");
     // print("from prepareSessionList the returned list _listOfSessionsTime == ${_listOfSessionsTime}");

     return sessionList;

  }

}





