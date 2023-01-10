import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../domain_layer/Model/TherapistData.dart';
import 'package:untitled/presentation_layer/PatientScreens/AddingClient/View/Component/InputFeild.dart';
import '../../../../../application_layer/utils/Constants.dart';
import '../../../../../application_layer/utils/Shared.dart';
import '../../../../../application_layer/utils/extensions.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/intl.dart';
import '../../../../../domain_layer/Model/Client.dart';
import '../../../../HomePage/View/home_screen.dart';
import '../../ViewModel/AddingClientVM.dart';
import '../../View/Component/TitlePage.dart';

class AddingClientPages extends StatefulWidget {
  const AddingClientPages({Key? key}) : super(key: key);

  @override
  State<AddingClientPages> createState() => _AddingClientPagesState();
}

class _AddingClientPagesState extends State<AddingClientPages> {

  final _clientNameController = TextEditingController();
  final _clientAgeController = TextEditingController();
  final _clientPriceController = TextEditingController();
  final _clientDurrationController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  var isCheckedMale =  false;
  var isCheckedFemale =  false;
  var totalCases = 1;
  var isTimeSelected = false;

  late TherapistData selectedTherapist ;
  late List<TherapistData> _listOftherapist ;
  
  
  List<DateTime> _listOfSelectedTime = [];
  Map< Specializations , List<DateTime>> _listOfSelectedCases = {};
  DateTime? selectedTime = DateTime.now();
  Gender? _clientGender;
  String? _clientTherapist;
  Specializations  _clientCase = Specializations.Speech_Therapist ;
  



  Widget specializationList( /*int index */){
    var values = Specializations.values;
    // print("index ${index}");
    // print("Map is empty ${_listOfSelectedCases.isEmpty }");
    // print("Map is lenght ${_listOfSelectedCases.length }");
    // var clientCase =
    // _listOfSelectedCases.isEmpty ?
    //
    // Specializations.Physiotherapist :
    //
    //       _listOfSelectedCases.length >= index ?
    //                 _listOfSelectedCases.keys.elementAt( index == 0 ? index : index - 1)
    //                           :Specializations.Physiotherapist;

    print("map ${_listOfSelectedCases}");
    return
      Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Material(
            elevation: 8,
            shadowColor: Colors.black87,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration:  BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border:  Border.all(color: Constants.RBackgroundColor)
              ),
              child:  DropdownButtonHideUnderline(
                child: DropdownButton<Specializations>(
                    isExpanded:true,
                    borderRadius: BorderRadius.circular(30),
                    value:    _clientCase ,
                    items:
                    Specializations.values.map((Specializations classType) {
                      return DropdownMenuItem<Specializations>(
                          value: classType,
                          child: Text(classType.name.toString()));
                    }).toList(),

                    onChanged: (value)  {


                      setState((){
                        values.contains(value) ?  this. _clientCase = value!  : print("not in values ") ;
                        print( _clientCase );
                        // _listOfSelectedCases.containsKey(_clientCase) ?  print("map conatins ${clientCase.name}") : _listOfSelectedCases.addAll(
                        //     {_clientCase : []});

                        print("MAP after adding a case ${_listOfSelectedCases}");
                      });
                    }
                ),
              ),
            ),
          )
        // ),
      );
  }

  Widget therapistDropDownList( AddingViewModel provider, List<TherapistData?> specificList ){
      // _clientTherapist =  items.isNotEmpty ? items[0] : "";

      print(specificList.length);
      print("therapistDropDownList = ${specificList.map((e) => e?.name)}");
      print("Case = ${_clientCase.name}");
      specificList.removeWhere((e) => e == null);
      List<String?> items = specificList.map((e) => e?.name).toList();
      print(items.length);
      print(_clientTherapist);
      return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: Container(
              decoration:  BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border:  Border.all(color: Constants.RBackgroundColor)
              ),
          child: DropdownButtonHideUnderline(
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
                      child: Text("${items}" , style:  TextStyle(color: Constants.kPrimaryColor  , fontSize: 17,),),
                    );
                  }).toList(),

              onChanged: (value){
                  setState((){
                    _clientTherapist = value  as String;
                  });
              }
              ),
          ),
        ),
        )
      );
  }


  ///TODO SELECTED TIME LIST VIEW
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
                      var prevSelection = _listOfSelectedTime.elementAt(i); //todo take the element from map {"" , [] };

                      var time = await pickTime(prevSelection) as TimeOfDay;

                      _listOfSelectedTime.removeAt(_listOfSelectedTime.indexOf(prevSelection)); //todo update the element from map {"" , [] };

                      var firstOfMonth = DateTime(prevSelection.year, prevSelection.month, prevSelection.weekday , time.hour , time.minute);

                      var firstDayPickedInMonth = firstOfMonth.addCalendarDays((7 - (firstOfMonth.weekday -  prevSelection.weekday)) % 7);

                      setState((){
                        handleTimeSelection(firstDayPickedInMonth /*, index:  i*/ );
                      });
                    },
                    child: Row (
                      children: [
                        Text("${DateFormat('EE HH:mm:aa').format(_listOfSelectedTime.elementAt(i)).toString()}"),
                        isTimeSelected ? Text("\t \t Busy" , style: TextStyle(color: Colors.red ,fontWeight: FontWeight.bold))  : Text(""),
                      ],
                    ))
            ),

            IconButton(onPressed: (){
              //deleting Selected time
              setState((){
               _listOfSelectedTime.removeAt(i);
               isTimeSelected = false;
               print("isTimeSelected");
               print(isTimeSelected);
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


  ///TODO THE HOLE
  /// conatins List of selected Widget
  // Widget _listOfCases(AddingViewModel provider , List<bool> values) {
  //
  //   var List =  <Widget> [];
  //
  //   print("_listOfCases ${totalCases}   ==> listOfCASE()");
  //   for(var i = 0 ; i < totalCases ; i++){
  //     List.add(
  //       // Padding(
  //       //   padding: const EdgeInsets.all(8.0),
  //       //   child:
  //         Material(
  //           elevation: 8,
  //           shadowColor: Colors.black87,
  //           color: Colors.transparent,
  //           borderRadius: BorderRadius.circular(30),
  //           child: Container(
  //
  //             decoration:  BoxDecoration(
  //
  //                 color: Colors.grey,
  //                 borderRadius: BorderRadius.circular(30),
  //                 border:  Border.all(color: RBackgroundColor)
  //             ),
  //             child: Container(
  //               margin: EdgeInsets.all(9.0),
  //               child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   "\t Client`s case:",
  //                   style: TextStyle(color: kPrimaryColor, fontSize: 17),
  //                 ),
  //                 //Case of the Client
  //                 specializationList( i ),
  //
  //                 const  Text("\t Sessions Schedule" ,style: TextStyle(color: kPrimaryColor , fontSize: 17),),
  //
  //
  //                 WeekdaySelector(
  //                   firstDayOfWeek: 7,
  //                   selectedElevation: 30,
  //                   color :kPrimaryColor ,
  //                   onChanged: (val) async {
  //
  //                     var now = DateTime.now();
  //                     var time = await pickTime(now) as TimeOfDay;
  //
  //                     setState((){
  //
  //                       var now = DateTime.now();
  //
  //                       var firstOfMonth = DateTime(now.year, now.month, val , time.hour , time.minute);
  //
  //                       var firstDayPickedInMonth = firstOfMonth.addCalendarDays((7 - (firstOfMonth.weekday - val)) % 7);
  //
  //                       handleTimeSelection(firstDayPickedInMonth , index : i);
  //
  //
  //                       // print(_listOfSelectedTime);
  //                     });
  //                   },
  //                   values: values,
  //                 ),
  //
  //                 _listOfSelectedTime.isNotEmpty ?
  //                 _listOfSelectedTimeWidget(        /* _clientCase.name*/) : Container(),
  //
  //
  //                 const  Text(
  //                   "\t Client`s therapist:",
  //                   style: TextStyle(color: kPrimaryColor, fontSize: 17),
  //                 ),
  //
  //                 //todo: therapist
  //                 _listOftherapist.isNotEmpty
  //                     ? therapistDropDownList (provider.therapists)//(_listOftherapist)
  //                     : Container(),
  //               ],
  //               // )
  //     ),
  //             ),
  //           ),
  //         ),
  //       // ),
  //     );
  //   };
  //
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: List,
  //   );
  // }



  Widget _GenderButtons(Gender gender , bool isChecked){

    return
      Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(

              color:isChecked?  Colors.blue.shade200 :Colors.white,
              borderRadius: BorderRadius.circular(30),
              border:  Border.all(color: Constants.RBackgroundColor)
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

                  setState((){
                    if (gender.name == "Female"){
                      isCheckedMale =  isCheckedFemale;
                      isCheckedFemale = !isCheckedFemale;
                    }
                    else{
                      isCheckedFemale = isCheckedMale;
                      isCheckedMale = !isCheckedMale;
                    }
                    print(isCheckedFemale);
                    isCheckedFemale ? _clientGender = Gender.Female : _clientGender = Gender.Male ;
                    isCheckedMale ? _clientGender = Gender.Male : _clientGender = Gender.Female ;
                    print(_clientGender);
                  });

                },
            )

          ),
        );
  }

  @override
  initState(){

    Provider.of<AddingViewModel>(context , listen:  false).getTherapistsMails();
    _listOftherapist =  Provider.of<AddingViewModel>(context , listen:  false).therapists.cast<TherapistData>();
    _clientTherapist = Provider.of<AddingViewModel>(context , listen:  false).clientTherapist;

    print("initState");
    print(_clientTherapist);
    // list.add(AddCase(provider));
    // _clientTherapist = _addingVM.therapists.first;
  }


  @override
  Widget build(BuildContext context) {
    List<bool> values = List.filled(7, false);
    print("Widgetbuild");
    print(_clientTherapist);
    return Consumer<AddingViewModel>(builder: (context, provider, child) {

      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitlePage(title: " New Patient ", icon : Icons.person_add_alt ),

              const SizedBox(width: 30, height: 40,),
              //Name of the client
              InputFeild(hint: "Yasser", iconData: Icons.person, txtController: _clientNameController, keyType: TextInputType.name, label: "Name"),

              //Age of the Client
              InputFeild(hint: "12", iconData: Icons.person, txtController: _clientAgeController, keyType: TextInputType.number, label: "Age"),

              const SizedBox(width: 30, height: 20,),


              //todo Gender session
              Text("\t \tGender: \t" ,style: TextStyle(color: Constants.kPrimaryColor , fontSize: 17),),

              const SizedBox(width: 30, height: 10,),

              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                _GenderButtons(_clientGender = Gender.Female , isCheckedFemale),
                _GenderButtons(_clientGender = Gender.Male , isCheckedMale),
              ],
            ),
              const  SizedBox(width: 30, height: 20,),

              //phone Number
              InputFeild(hint: "012222222222", iconData: Icons.phone_android, txtController: _clientPhoneController, keyType: TextInputType.phone, label: "Phone Number"),

              //Price
              InputFeild(hint: "120", iconData: Icons.money, txtController: _clientPriceController, keyType: TextInputType.number, label: "Price"),

              //Duration
              InputFeild(hint: "30", iconData: Icons.timer, txtController: _clientDurrationController, keyType: TextInputType.number, label: "Durration in MIN"),

              const SizedBox(
                height: 15,
              ),

              //Sessions case and therapist
            Row(
                children: [
                  Text("Add Case"),
                  IconButton(onPressed: (){
                    setState((){
                      totalCases ++;
                      print("totalCases from tap = ${totalCases}");
                    });
                  }, icon: Icon(Icons.add))

                ],
              ),
            // _listOfCases(provider, values),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "\t Client`s case:",
                  style: TextStyle(color: Constants.kPrimaryColor, fontSize: 17),
                ),
                //Case of the Client
                specializationList(),

                  Text("\t Sessions Schedule" ,style: TextStyle(color: Constants.kPrimaryColor , fontSize: 17),),


                WeekdaySelector(
                  firstDayOfWeek: 7,
                  selectedElevation: 30,
                  color : Constants.kPrimaryColor ,
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


                Text(
                  "\t Client`s therapist:",
                  style: TextStyle(color: Constants.kPrimaryColor, fontSize: 17),
                ),

                //todo: therapist
                _listOftherapist.isNotEmpty
                    ? therapistDropDownList ( provider,
                    provider.therapists.map((e){
                      if(e.specialization == _clientCase.name){

                        _clientTherapist = e.name;

                        return e;
                      }
                    } ).toList().cast()
                )//(_listOftherapist)
                 : Container(),
              ],
              // )
            ),





              const SizedBox(
                height: 50,
              ),

              ///todo AddingButton

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
                  child:  Text(
                    "\t Add Patient \t",
                    style:  TextStyle(
                      color: Constants.kPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){

                      var sessionList = prepareSessionList(_listOfSelectedTime);
                      print("condition");
                      // check all in puts
                      if (_formKey.currentState!.validate()) {
                          print("condition");
                          if (_listOfSelectedTime.isEmpty){

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please Select Session Time ')),
                              );

                          }
                          else{
                          var client =
                          Patient(0,
                            name: _clientNameController.text,
                            age: int.parse(_clientAgeController.text),
                            therapist: _clientTherapist ?? "",
                            caseName: _clientCase.name,
                            startDate: DateTime.now(),
                            storedAt: DateTime.now(),
                            storedBy: SharedPref.email,
                            sessions: { _clientCase.name : sessionList},
                            Durration: int.parse(_clientDurrationController.text),
                            price: int.parse(_clientPriceController.text),
                            phone: int.parse(_clientPhoneController.text),
                            gender: _clientGender?.name ?? "male"
                        );

                          Provider.of<AddingViewModel>(context , listen:  false).addClient(client , selectedTherapist );
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => HomePageScreen()));
                      }

                      }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ],
          ),
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

  handleTimeSelection(DateTime firstDayPickedInMonth, /*{required int index}*/){

    print("firstDayPickedInMonth");
    print(firstDayPickedInMonth);
    //todo check the firstday if it less than current do not add it
    if (firstDayPickedInMonth.day < DateTime.now().day){

      var nextDayInMonth = firstDayPickedInMonth.addCalendarDays(1 * 7);
      print("nextDayInMonth");
      print(nextDayInMonth);
      //store in map

      //todo _____________________________________________________________________________________________//
      // _listOfSelectedCases [_listOfSelectedCases.keys.elementAt(index)]?.add( firstDayPickedInMonth.addCalendarDays(1 * 7));
      // print("map after adding the time ${_listOfSelectedCases}");
      //todo _____________________________________________________________________________________________//

      var time = nextDayInMonth.addCalendarDays(1 * 7);

      print("time");
      print(time);
      _listOfSelectedTime.add(time);
      checkAvailability(time);

    }
    else{
      _listOfSelectedTime.add(firstDayPickedInMonth);
    }

  }

  checkAvailability(DateTime selectedTime){



    //todo get the therapist object
     _listOftherapist.forEach((element) {
      if (element.name == _clientTherapist){
        selectedTherapist = element;
      }
      });


     print("selectedTime");
     print(selectedTime);
    //todo check the session map
      var allSessions = selectedTherapist.sessions.values.toList();
      print("allSessions");
      allSessions.forEach((element) {


       if( element.contains(selectedTime) ) {
         setState(() {
           isTimeSelected = true;
         });
       }
      });
      print("selected therapist ${selectedTherapist.name}");




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
// Widget caseDropDownList(List<dynamic> items){
//
//   return
//     Padding(
//       padding: const EdgeInsets.all(8.0),
//       child:        Material(
//           elevation: 8,
//           shadowColor: Colors.black87,
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(30),
//           child: Container(
//             decoration:  BoxDecoration(
//
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 border:  Border.all(color: RBackgroundColor)
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton(
//                   isExpanded:true,
//                   borderRadius: BorderRadius.circular(30),
//                   hint: const Text("Case"),
//                   value: _clientCase,
//                   items:
//                   items.map((items) {
//                     return DropdownMenuItem(
//                       value: items,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(items , style: TextStyle( fontSize: 17),),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value){
//                     setState((){
//                       this._clientCase = value.toString();
//                     });
//                   }
//               ),
//             ),
//           )
//       ),
//     );
// }




// List<Widget> AddCase(AddingViewModel provider ){
//   print("list lenght form function ${customWidget.length}");
//   print("total case  ${totalCases}");
//   List<bool> values = List.filled(7, false);
//   if (totalCases != 1) {
//     var loop = totalCases - customWidget.length;
//     print("loop = ${loop}");
//     for (var i = 1 ; i <= loop   ; i ++) {
//       customWidget.add(
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               color: Colors.red,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "\t Client`s case:",
//                     style: TextStyle(color: kPrimaryColor, fontSize: 17),
//                   ),
//                   //Case of the Client
//                   caseDropDownList(items),
//
//                   const  Text("\t Sessions Schedule" ,style: TextStyle(color: kPrimaryColor , fontSize: 17),),
//
//
//                   WeekdaySelector(
//                     firstDayOfWeek: 7,
//                     selectedElevation: 30,
//                     color :kPrimaryColor ,
//                     onChanged: (val) async {
//
//                       var now = DateTime.now();
//                       var time = await pickTime(now) as TimeOfDay;
//
//                       setState((){
//
//                         var now = DateTime.now();
//
//                         var firstOfMonth = DateTime(now.year, now.month, val , time.hour , time.minute);
//
//                         var firstDayPickedInMonth = firstOfMonth.addCalendarDays((7 - (firstOfMonth.weekday - val)) % 7);
//
//                         handleTimeSelection(firstDayPickedInMonth);
//
//
//                         print(_listOfSelectedTime);
//                       });
//                     },
//                     values: values,
//                   ),
//
//                   _listOfSelectedTime.isNotEmpty ?
//                   _listOfSelectedTimeWidget(_clientCase) : Container(),
//
//
//                   const  Text(
//                     "\t Client`s therapist:",
//                     style: TextStyle(color: kPrimaryColor, fontSize: 17),
//                   ),
//
//                   //todo: therapist
//                   _listOftherapist.isNotEmpty
//                       ? therapistDropDownList (provider.therapists)//(_listOftherapist)
//                       : Container(),
//                 ],
//                 // )
//               ),
//             ),
//           ));
//     }
//   }
//
//   return customWidget;
// }