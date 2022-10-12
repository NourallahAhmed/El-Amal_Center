import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Model/TherapistData.dart';
import '../../../../utils/Constants.dart';
import '../viewModel/All_TherapistVM.dart';

class All_Therapist_Screen extends StatefulWidget {
  const All_Therapist_Screen({Key? key}) : super(key: key);

  @override
  State<All_Therapist_Screen> createState() => _All_Therapist_ScreenState();
}

class _All_Therapist_ScreenState extends State<All_Therapist_Screen> {
  var  alltTherapistsList = [];

  Widget therapistRow(TherapistData therapist) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
            elevation: 8,
            shadowColor: Colors.black87,
            color: RBackgroundColor,
            borderRadius: BorderRadius.circular(30),
            child: Row(children: [
              SizedBox(
                width: 90,
                height: 90,
                child: therapist.gender == "male"
                    ? Image.asset('assets/images/man.png')
                    : Image.asset('assets/images/woman.png'),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${therapist.name}",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: kSecondaryColor),
                  ),
                  Text(
                    "${therapist.specialization}",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: kSecondaryColor),
                  ),


                ],
              ),
              const SizedBox(width: 20,),
              IconButton(onPressed: (){



                Provider.of<All_TherapistVM>(context , listen: false).deleteTherapist(therapist);

              }, icon: Icon(Icons.delete))
            ])
    )
    );
  }

  @override
  initState(){
    print("initState");
    Provider.of<All_TherapistVM>(context , listen: false).getAllTherapist();
    alltTherapistsList = Provider.of<All_TherapistVM>(context , listen: false).Therapists;

  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<All_TherapistVM>(builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("El Amal Center"),
          ),
          body: SingleChildScrollView(
              child: SizedBox(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemBuilder: (BuildContext context, int index) {
                final therapist = Provider.of<All_TherapistVM>(context , listen: false).Therapists[index];
                return  therapistRow(therapist);
            },
            itemCount:  Provider.of<All_TherapistVM>(context , listen: false).Therapists.length ?? 0,
          ),
              )
          ),
        );
    }
    );
  }
}
