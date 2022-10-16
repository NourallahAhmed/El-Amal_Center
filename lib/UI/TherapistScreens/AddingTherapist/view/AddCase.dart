import 'package:flutter/material.dart';
import 'package:untitled/UI/PatientScreens/AddingClient/ViewModel/AddingClientVM.dart';
import 'package:untitled/utils/extensions.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../../../../utils/Constants.dart';
import '../../../../utils/Shared.dart';
import 'CaseDropDownList.dart';
import 'package:intl/intl.dart';

class AddCase extends StatefulWidget {
  late AddingViewModel provider;

  AddCase({Key? key, required AddingViewModel provider}) : super(key: key);

  @override
  State<AddCase> createState() => _AddCaseState(this.provider);
}

class _AddCaseState extends State<AddCase> {
  late List<String> _listOftherapist ;
  List<DateTime> _listOfSelectedTime = [];
  List<bool> values = List.filled(7, false);
  String _clientTherapist  = SharedPref.email;
  AddingViewModel provider;
  _AddCaseState(this.provider);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "\t Client`s case:",
          style: TextStyle(color: kPrimaryColor, fontSize: 17),
        ),
        //Case of the Client
        // caseDropDownList(items),
        CaseDropDownList(cases: ["case1" , "case2"],) ,

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
            ? therapistDropDownList (provider.therapists)//(_listOftherapist)
            : Container(),
      ],
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
 Widget therapistDropDownList(List<dynamic> items ){
   // _clientTherapist =  items.isNotEmpty ? items[0] : "";

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
                 border:  Border.all(color: RBackgroundColor)
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
                       child: Text(items , style:  TextStyle(color: kPrimaryColor  , fontSize: 17,),),
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
}

