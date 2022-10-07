import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/utils/Shared.dart';

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
  List<DateTime>_listOfTime = [];
  final _clientNameController = TextEditingController();
  final _clientAgeController = TextEditingController();
  final _clientPriceController = TextEditingController();
  final _clientDurrationController = TextEditingController();
  final _clientTotalSessionController = TextEditingController();
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
        child: Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
    ),
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
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
        child: DropdownButton(
            isExpanded:true,
          borderRadius: BorderRadius.circular(20),
            hint: const Text("Therapist"),
            value: _clientTherapist,
            items:
              items.map((items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),

          onChanged: (value){
              setState((){
                _clientTherapist = value  as String;
              });
          }
          ),
      )
      );
  }

  Widget sessionDays(){
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (BuildContext context, int index) {

        return Row(
          children: [
              IconButton( onPressed: () {
                DateTime? dateTime = showDateTimePicker() as DateTime?;
                dateTime == null  ? print("null") : _listOfTime.add(dateTime);
                print(_listOfTime);
              }, icon: Icon( Icons.calendar_today_outlined)),

            _listOfTime.isNotEmpty ?
            Text("${_listOfTime[index].day}- ${_listOfTime[index].month} -${_listOfTime[index].year}    ${_listOfTime[index].hour}:${_listOfTime[index].minute}"):
                Container(),
          ],
        );
      },
      itemCount: int.parse(_clientTotalSessionController.text.toString()),
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
    print(_listOftherapist);
    print(_clientTherapist);
    return Consumer<AddingViewModel>(builder: (context, provider, child) {
      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(

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

            //NumberOfSession
            inputFeild("3", Icons.timer, _clientTotalSessionController, TextInputType.number, "Number of sessions"),

            //Sessions
            _clientTotalSessionController.text.isEmpty ? Container()  : Container(
                width: double.infinity,
                height: 100,
                child: sessionDays()),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     children: _clientTotalSessionController.text.isEmpty ? [ Container() ] : sessionDays(),
            //   ),
            // ),

            //Case of the Client
            caseDropDownList(items),
            //therapist
            _listOftherapist.isNotEmpty ? therapistDropDownList( _listOftherapist) : Container(),





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
