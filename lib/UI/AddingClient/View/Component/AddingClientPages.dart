import 'package:flutter/material.dart';

import '../../ViewModel/AddingClientVM.dart';

class AddingClientPages extends StatefulWidget {
  const AddingClientPages({Key? key}) : super(key: key);

  @override
  State<AddingClientPages> createState() => _AddingClientPagesState();
}

class _AddingClientPagesState extends State<AddingClientPages> {

  var _addingVM = AddingViewModel();
  var time = DateTime.now();
  var items = ["one" , "two" , "Speech Therapy"];


  var _listOftherapist = [];
  var _clientCase = "Speech Therapy";
  var _clientTherapist = "";
  var _listOfTime = [];
  final _clientNameController = TextEditingController();
  final _clientAgeController = TextEditingController();
  final _clientCaseController = TextEditingController();
  final _clientPriceController = TextEditingController();
  final _clientDurrationController = TextEditingController();
  final _clientTotalSessionController = TextEditingController();




  Widget inputFeild(String hint, IconData iconData , TextEditingController txtController , TextInputType keyType){
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

              prefixIcon: Icon(iconData),
            ),

          )

      ),
    );
  }
  
  Widget caseDropDownList(List<dynamic> items ){
    return
      Padding(
        padding: const EdgeInsets.all(9.0),

        child: DropdownButton(
            isExpanded:true,
          borderRadius: BorderRadius.circular(20),

            value: _clientCase,
            items:
              items.map((items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),


          onChanged: (value){
              setState((){
                _clientCase = value  as String;
              });
          }
          ),
      );
  }

  Widget therapistDropDownList(List<dynamic> items ){


    setState((){
      _clientTherapist =  items.isNotEmpty ? items[0] : "";

    });


    return
      Padding(
        padding: const EdgeInsets.all(9.0),

        child: DropdownButton(
            isExpanded:true,
          borderRadius: BorderRadius.circular(20),

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
      );
  }

  List<Widget> sessionDays(int num ){
    var list = <Widget>[];
    for(  var i = 0; i < num ; i++){
      DateTime? selectedTime = DateTime.now();

      list.add(
      Row(
        children: [
          IconButton(onPressed: () => selectedTime = showDateTimePicker() as DateTime?, icon: Icon(Icons.punch_clock)),
          Text("${selectedTime?.year}/${selectedTime?.month}/${selectedTime?.day} ${selectedTime?.hour}:${selectedTime?.minute}")
        ],
      )
      );
      _listOfTime.add(selectedTime);
    }
    return list;
    // return list.isNotEmpty ? ListView(
    //   children: list,
    // ) : Text("\\\\");

  }
  


  @override
  initState(){
    _addingVM.getAllTherapist();

    setState((){


      ///Provider
      _listOftherapist = _addingVM.getListOfTherapist();


      _clientTherapist =  _listOftherapist.isNotEmpty?  _listOftherapist[0] : "" ;
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(

          children: [
            //Name of the client
            inputFeild("Yasser", Icons.person, _clientNameController, TextInputType.name),

            //Age of the Client
            inputFeild("12", Icons.person, _clientAgeController, TextInputType.number),

            //Case of the Client
            caseDropDownList(items),

            //therapist

            therapistDropDownList(_listOftherapist.isNotEmpty? _listOftherapist : []),

          //Price
          inputFeild("120", Icons.money, _clientPriceController, TextInputType.number),


          //Duration
          inputFeild("30", Icons.timer, _clientDurrationController, TextInputType.number),


            //NumberOfSession
          inputFeild("3", Icons.timer, _clientTotalSessionController, TextInputType.number),

            //Sessions

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: _clientTotalSessionController.text.isEmpty ? [ Container() ] : sessionDays(int.parse(_clientTotalSessionController.text.toString())),
              ),
            ),



          ],
        ),
      ),
    );
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
