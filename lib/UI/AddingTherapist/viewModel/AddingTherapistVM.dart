import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/Model/TherapistData.dart';

class AddingTherapistVM{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var errorMsg = "";
  var listOfEmails = [];


  Future<void> getAllMails() async{

  }


  Future<void> addTherapist(TherapistData therapist) async {

    //todo -> store in firebaseDatabase
    print(therapist.sessions);


     await FirebaseFirestore.instance.collection("Therapists").doc(therapist.mail).set(
        therapist.toJson()
    ).onError((error, stackTrace) => print("Error in fireStore ${error} , stackTrace ${stackTrace}"))
    .then((value)  async {
       //todo -> auth

       UserCredential userCredential = await _auth
           .createUserWithEmailAndPassword
         (email: therapist.mail, password: therapist.password)
           .catchError((error) {
         errorMsg = error.toString();
         print("error in creating the Auth ${errorMsg}");
       });
     }
     );



  }

}