import 'package:flutter/material.dart';
import '../../../../presentation_layer/HomePage/View/Component/sessions_view.dart';

import '../../../../domain_layer/Model/patient.dart';
import '../../../../application_layer/utils/Constants.dart';

class ClientRow extends StatelessWidget {
  Patient patient ;
  DateTime selectedDay;
  ClientRow({Key? key , required this.patient  , required this.selectedDay }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color:  Constants.RBackgroundColor,
        borderRadius: BorderRadius.circular(30),
        child:  Row(

          children: [
            SizedBox(
              width: 90,
              height: 90,
              child:    patient.gender == "male" ? Image.asset('assets/images/man.png') : Image.asset('assets/images/woman.png')  ,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "${patient.name}",
                  style:  TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: Constants.kSecondaryColor),
                ),
                Text(
                  "${patient.caseName}",
                  style:  TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: Constants.kSecondaryColor),
                ),
                Text(
                  "Therapist: ${patient.therapist /*.substring(0,client.therapist.lastIndexOf("@"))*/}",
                  style:  TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: Constants.kSecondaryColor),
                ),
                Text(
                  "Durration: ${patient.Durration} min",
                  style:  TextStyle(fontSize: 15, fontWeight: FontWeight.normal , color: Constants.kSecondaryColor),
                ),
              ],
            ),

            const SizedBox(width: 20,),


            //MARK: passing only the list of time
            SessionViews( selectedDay: selectedDay, sessionsMap: patient.sessions ,) ,

          ],
        ),
      ),
    );
  }
}
