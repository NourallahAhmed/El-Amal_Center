import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/UI/AddingClient/View/Component/InputFeild.dart';
import 'package:untitled/utils/Shared.dart';
import 'package:untitled/utils/extensions.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/intl.dart';
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

  var items = ["case1" , "case2" , "case3"];

  late List<String> _listOftherapist ;
  String _clientCase = "case1";
  String _clientTherapist  = SharedPref.userName;
  // late String _clientTherapist ;
  List<DateTime> _listOfSessionsTime = [];
  List<DateTime> _listOfSelectedTime = [];
  final _clientNameController = TextEditingController();
  final _clientAgeController = TextEditingController();
  final _clientPriceController = TextEditingController();
  final _clientDurrationController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  var list = <Widget>[];
  DateTime? selectedTime = DateTime.now();



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


  @override
  initState(){



      //ERROR the provider do not notify the view with the data

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
            TitlePage(title: " New Patient ", icon : Icons.person_add_alt_1_rounded ),

            SizedBox(width: 30,),
            //Name of the client
            InputFeild(hint: "Yasser", iconData: Icons.person, txtController: _clientNameController, keyType: TextInputType.name, label: "Name"),

            //Age of the Client
            InputFeild(hint: "12", iconData: Icons.person, txtController: _clientAgeController, keyType: TextInputType.number, label: "Age"),

            //phone Number
            InputFeild(hint: "012222222222", iconData: Icons.phone_android, txtController: _clientPhoneController, keyType: TextInputType.phone, label: "Phone Number"),
            //Price
            InputFeild(hint: "120", iconData: Icons.money, txtController: _clientPriceController, keyType: TextInputType.number, label: "Price"),

            //Duration
            InputFeild(hint: "30", iconData: Icons.timer, txtController: _clientDurrationController, keyType: TextInputType.number, label: "Durration"),

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
                        style: TextStyle(color: kPrimaryColor, fontSize: 15),
                      ),
                      //Case of the Client
                      caseDropDownList(items),

                      const  Text("\t Sessions Schedule" ,style: TextStyle(color: kPrimaryColor , fontSize: 15),),


                      WeekdaySelector(
                        firstDayOfWeek: 7,
                        selectedElevation: 30,
                        color :kPrimaryColor ,
                        onChanged: (val) async {

                          var now = DateTime.now();
                          var time = await pickTime(now) as TimeOfDay;
                          print("onChanged");
                          setState((){

                            var now = DateTime.now();

                            var firstOfMonth = DateTime(now.year, now.month, val , time.hour , time.minute);

                            var firstDayPickedInMonth = firstOfMonth.addCalendarDays((7 - (firstOfMonth.weekday - val)) % 7);

                            handleTimeSelection(firstDayPickedInMonth);
                            // extract to separate function
                            // //todo handle schedule for 2 month = 8 week == 8 loops
                            // for (var week = 1 ; week <= 9 ; week ++){
                            //   print("nextDay in ${week} ${firstDayPickedInMonth.addCalendarDays(week * 7)}");
                            //   _listOfSessionsTime.add(firstDayPickedInMonth.addCalendarDays(week * 7));
                            // }

                            print(_listOfSelectedTime);
                          });
                        },
                        values: values,
                      ),


                    _listOfSelectedTime.isNotEmpty ?
                      _listOfSelectedTimeWidget()

                        : Container(),

                      // const SizedBox(
                      //   height: 15,
                      // ),

                     const  Text(
                        "\t Client`s therapist:",
                        style: TextStyle(color: kPrimaryColor, fontSize: 15),
                      ),

                      //todo: therapist
                   _listOftherapist.isNotEmpty
                          ? therapistDropDownList(_listOftherapist)
                          : Container(),
                    ],
                  )),


            //
            // ElevatedButton(
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            //           (Set<MaterialState> states) {
            //         if (states.contains(MaterialState.pressed))
            //           return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            //         return null; // Use the component's default.
            //       },
            //     ),
            //   ), child: Icon(Icons.add),
            //   onPressed: (){
            //
            //   },
            // ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     onPrimary: Theme.of(context).colorScheme.onPrimary,
            //     onSurface: Theme.of(context).colorScheme.primary,
            //   ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            //   onPressed: (){},
            //   child: const Text('Filled'),
            // ),

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
      print("added");
    }

  }


}





