import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/utils/Shared.dart';
import 'package:untitled/utils/extensions.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../ViewModel/AddingClientVM.dart';
import '../../../../utils/Constants.dart';

class AddingClientPages extends StatefulWidget {
  const AddingClientPages({Key? key}) : super(key: key);

  @override
  State<AddingClientPages> createState() => _AddingClientPagesState();
}

class _AddingClientPagesState extends State<AddingClientPages> {

  var _addingVM = AddingViewModel();
  var time = DateTime.now();
  var items = ["case1" , "case2" , "case3"];


  late List<String> _listOftherapist ;
  String _clientCase = "case1";
  String _clientTherapist  = SharedPref.userName;
  List<DateTime> _listOfSessionsTime = [];
  final _clientNameController = TextEditingController();
  final _clientAgeController = TextEditingController();
  final _clientPriceController = TextEditingController();
  final _clientDurrationController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  var list = <Widget>[];
  DateTime? selectedTime = DateTime.now();



  Widget inputFeild(String hint, IconData iconData , TextEditingController txtController , TextInputType keyType , String label){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            keyboardType: keyType,
            controller: txtController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              labelText: label,
              prefixIcon: Icon(iconData),
            ),

          )

      ),
    );
  }
  
  Widget caseDropDownList(List<dynamic> items ){

    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:/* Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        child:*/ DropdownButton(
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
                    child: Text(items),
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

    // child: Material(
    //   elevation: 8,
    //   shadowColor: Colors.black87,
    //   color: Colors.white,
    //   borderRadius: BorderRadius.circular(30),
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
                  child: Text(items , style:  TextStyle(color: kPrimaryColor),),
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

  Widget titleOfPage(){
    return  Container(
      margin: const EdgeInsets.all(8.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
           Text(
            " New Patient ",
            style:  TextStyle(
                color: kPrimaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10,),
          Icon(Icons.person_add_alt_1_rounded, color: kPrimaryColor, size: 50,),

        ],
      ),
    );
  }

  @override
  initState(){
      _addingVM.getAllTherapist();
      _listOftherapist = _addingVM.therapists;

  }
  
  @override
  Widget build(BuildContext context) {
    print("from build");
    List<bool> values = List.filled(7, false);
    return Consumer<AddingViewModel>(builder: (context, provider, child) {
      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleOfPage(),
            SizedBox(width: 30,),
            //Name of the client
            inputFeild("Yasser", Icons.person, _clientNameController, TextInputType.name , "Name"),

            //Age of the Client
            inputFeild("12", Icons.person, _clientAgeController, TextInputType.number , "Age"),

            //phone Number
            inputFeild("012222222222", Icons.phone_android, _clientPhoneController, TextInputType.phone, "Phone Number"),
            //Price
            inputFeild("120", Icons.money, _clientPriceController, TextInputType.number , "Price"),

            //Duration
            inputFeild("30", Icons.timer, _clientDurrationController, TextInputType.number,"Durration"),

            const SizedBox(
              height: 15,
            ),

            //Sessions
            // case and therapist
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "\t Client`s case:",
                        style: TextStyle(color: kPrimaryColor, fontSize: 15),
                      ),
                      //Case of the Client
                      caseDropDownList(items),
                      const SizedBox(
                        height: 15,
                      ),

                     const  Text("\t Sessions Schedule" ,style: TextStyle(color: kPrimaryColor , fontSize: 15),),
                      WeekdaySelector(
                        firstDayOfWeek: 7,
                        // selectedHoverColor: Colors.red,
                        selectedFillColor: Colors.indigo,
                        // selectedFillColor: kPrimaryColor ,
                        // selectedFocusColor: Colors.blue,
                        fillColor : RBackgroundColor,
                        selectedElevation: 15,
                        elevation: 5,
                        disabledElevation: 0,
                        color :kPrimaryColor ,
                        onChanged: (val) async {
                          var time = await pickTime() as TimeOfDay;
                          setState((){

                            var now = DateTime.now();

                            var firstOfMonth = DateTime(now.year, now.month, val , time.hour , time.minute);

                            var firstDayPickedInMonth = firstOfMonth.addCalendarDays((7 - (firstOfMonth.weekday - val)) % 7);; // with Time picked
                            //todo check the firstday if it less than current do not add it
                            if (firstDayPickedInMonth.day < DateTime.now().day){
                              // do not add it
                            }
                            else{

                              _listOfSessionsTime.add(firstDayPickedInMonth);
                            }
                            //todo handle schedule for 2 month = 8 week == 8 loops
                            for (var week = 1 ; week <= 9 ; week ++){
                              print("nextDay in ${week} ${firstDayPickedInMonth.addCalendarDays(week * 7)}");
                              _listOfSessionsTime.add(firstDayPickedInMonth.addCalendarDays(week * 7));
                            }

                            print(_listOfSessionsTime);
                          });
                        },
                        values: values,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    const  Text(
                        "\t Client`s therapist:",
                        style: TextStyle(color: kPrimaryColor, fontSize: 15),
                      ),

                      //therapist
                      _listOftherapist.isNotEmpty
                          ? therapistDropDownList(_listOftherapist)
                          : Container(),
                    ],
                  )),



            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                    return null; // Use the component's default.
                  },
                ),
              ), child: Icon(Icons.add),
              onPressed: (){

              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).colorScheme.onPrimary,
                onSurface: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: (){},
              child: const Text('Filled'),
            ),

            ],
        ),
      ),
    );
  });
  }


   Future<TimeOfDay?> pickTime() => showTimePicker(context: context, initialTime: TimeOfDay(hour: time.hour, minute: time.minute));
   Future<DateTime?> pickDate() => showDatePicker(context: context, initialDate: time, firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year + 25));
   Future<DateTime?> showDateTimePicker() async {
   DateTime? date = await pickDate();
   if (date != null ) {
     TimeOfDay? time = await pickTime();
     if (time != null){
        final dateTime = DateTime(date.year,date.month,date.year,time.hour, time.minute);
        return dateTime;
     }
   }
 }

}
