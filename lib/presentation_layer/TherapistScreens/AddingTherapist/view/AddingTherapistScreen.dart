


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain_layer/Model/TherapistData.dart';
import 'package:untitled/presentation_layer/PatientScreens/AddingClient/View/Component/InputFeild.dart';

import '../../../../application_layer/utils/Constants.dart';
import '../../../../application_layer/utils/Shared.dart';
import '../../../PatientScreens/AddingClient/View/Component/TitlePage.dart';
import '../../../HomePage/View/home_screen.dart';
import '../viewModel/AddingTherapistVM.dart';
class AddingTherapistScreen extends StatefulWidget {
  const AddingTherapistScreen({Key? key}) : super(key: key);

  @override
  State<AddingTherapistScreen> createState() => _AddingTherapistScreenState();
}

class _AddingTherapistScreenState extends State<AddingTherapistScreen> {

  final _formKey = GlobalKey<FormState>();

  final _therapistSpecializeController = TextEditingController();

  final _therapistNameController = TextEditingController();

  final _therapistMailController = TextEditingController();

  final _therapistPasswordController = TextEditingController();

  final _therapistPhoneController = TextEditingController();

  Gender _therapistGender = Gender.Male;
  Specializations _therapistSpecialize = Specializations.Physiotherapist ;

  var sessions = {
    "session1":[DateTime.now()]
  };


  // var _addingVM = AddingTherapistVM();
  var isCheckedMale =  false;
  var isCheckedFemale =  false;
  Widget _GenderButtons(Gender gender , bool isChecked ){

    return
      Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(

                color:  isChecked?  Colors.blue.shade200 :Colors.white,
                borderRadius: BorderRadius.circular(30),
                border:  Border.all(color: Constants.RBackgroundColor)
            ),
            child:
            GestureDetector(
              child:  Row(
                children: [
                  Text("${gender.name} " ),
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
                   isCheckedFemale ? _therapistGender = Gender.Female : _therapistGender = Gender.Male ;
                   isCheckedMale ? _therapistGender = Gender.Male : _therapistGender = Gender.Female ;
                  print(_therapistGender);
                });

              },
            )

        ),
      );
  }

  Widget specializationList(){

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
                    value: _therapistSpecialize,
                    items:
                    Specializations.values.map((Specializations classType) {
                      return DropdownMenuItem<Specializations>(
                          value: classType,
                          child: Text(classType.name.toString()));
                    }).toList(),

                    onChanged: (value)  {

                      var values = Specializations.values;
                      setState((){
                        values.contains(value) ?  this._therapistSpecialize = value!  : print("not in values ") ;
                        print(_therapistSpecialize);
                        print(_therapistSpecialize.runtimeType);
                      });
                    }
                ),
              ),
            ),
          )
        // ),
      );
  }


  @override
  initState(){
    Provider.of<AddingTherapistVM>(context , listen:  false).getAllMails();
  }
  @override
  Widget build(BuildContext context) {
    return
      Consumer<AddingTherapistVM>(builder: (context, provider, child) {
      return
      Scaffold(
          appBar:  AppBar(
            title:  Text("El Amal Center"),
          ),
          body:

      SingleChildScrollView(


        child: Form(
        key: _formKey,
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //todo title

            TitlePage(title: "Adding Therapist" , icon : Icons.person_add_alt),


            //todo NAME
            InputFeild(hint: "Nour",
                iconData: Icons.person,
                txtController: _therapistNameController,
                keyType: TextInputType.name,
                label: "Name"),

            //todo Phone
            InputFeild(hint: "012222222222",
                iconData: Icons.phone_android,
                txtController: _therapistPhoneController,
                keyType: TextInputType.phone,
                label: "Phone"),
            SizedBox(width: 30, height: 10,),

            //todo gender
            Text("\t \tGender: \t" ,style: TextStyle(color: Constants.kPrimaryColor , fontSize: 17),),

            SizedBox(width: 30, height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                _GenderButtons(_therapistGender = Gender.Female , isCheckedFemale),
                _GenderButtons(_therapistGender = Gender.Male , isCheckedMale),
              ],
            ),

            //todo Speciclaization -- > DropDownList
            SizedBox(
              height: 20,
            ),
            specializationList() ,

            //Email
            InputFeild(hint: "Nour@ElAmalCenter.com",
                iconData: Icons.mail_outline,
                txtController: _therapistMailController,
                keyType: TextInputType.emailAddress,
                label: "Mail"),

            //password
            InputFeild(hint: "123dsl",
                iconData: Icons.password,
                txtController: _therapistPasswordController,
                keyType: TextInputType.visiblePassword,
                label: "Password"),
            SizedBox(
              height: 30,
            ),
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
                  "\t Add Therapist \t",
                  style:  TextStyle(
                    color: Constants.kPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: (){
                  print("VALIDATION");
                  var checkMail = Provider.of<AddingTherapistVM>(context , listen:  false).listOfEmails.contains(_therapistMailController.text);
                  print("checkMail = ${checkMail}");
                  setState((){

                    Provider.of<AddingTherapistVM>(context, listen:  false).check = checkMail;
                  });

                  // check all in puts
                  if (_formKey.currentState!.validate()) {

                    if( checkMail == false ) {
                      print("checkMail = ${checkMail}");
                      var therapist =
                      TherapistData(
                        name: _therapistNameController.text,

                        specialization: _therapistSpecialize.name.toString(),
                        startDate: DateTime.now(),
                        storedAt: DateTime.now(),
                        storedBy: SharedPref.email,
                        sessions: sessions,
                        phone: int.parse(_therapistPhoneController.text),
                        gender: _therapistGender.name ,

                        password: _therapistPasswordController.text,
                        mail: _therapistMailController.text,
                      );

                      Provider.of<AddingTherapistVM>(context , listen:  false).addTherapist(therapist);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => HomePageScreen()));
                    }
                    else{
                      print("email Exist");
                    }
                  }
                },
              ),
            ),

          ],
        ),
        )
    )

    );
      });
  }
}
