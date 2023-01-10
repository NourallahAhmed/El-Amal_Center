
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
class PNServices{

  static var deviceToken = "";

  static var flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();
  //todo request permission from user device
  static requestPermission() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(

      alert: true,
      announcement:  false,
      badge:  true,
      carPlay:  false,
      criticalAlert: false,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted permission");
    }
    else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");
    }
    else{
      print("User declined or has not accepted permission");
    }

  }



  static getToken(String email) async {

  await FirebaseMessaging.instance.getToken().then(

      (token){

        PNServices.deviceToken = token!;
        print("device Token : ${deviceToken}");
        saveToken(PNServices.deviceToken , email);
      }
  );
  }

  static saveToken(String token , String email) async {

    //save in FireStore DataBase

    print("saveToken ${email}");

    //todo after login to take the email
    await FirebaseFirestore.instance.collection("Tokens").doc(email).set(
      {
        "name" : "${email}",
        "token" : token,
      }
    );
  }

  static initInfo(){
    //todo initialize flutter local notifications

    var androidInitialize = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize , iOS: iosInitialize);



    // for foreground
    PNServices.flutterLocalNotificationsPlugin.initialize(initializationsSettings,

      onDidReceiveNotificationResponse:
          ( payload) async {

            try{
              if(payload != null) {



              } else{

              }

            }
            catch(e){
              print(e.toString());
            }
      },

    );



    //from Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("_________ onMessage____________");
      print("onMessage: ${message.notification?.title} / ${message.notification?.body}");

      // start of local notifiction to show the notification

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString() , htmlFormatBigText:  true
      );


      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'dbfood', 'dbfood' ,
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority:  Priority.max,
      playSound: true,
      );


      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());


      await flutterLocalNotificationsPlugin.show(0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: message.data['title']
      );
    });

  }


  static sendPushMessage(String token , String body , String title) async{

    print("SendPushMessage");
    print(token);
    print(body);
    print(title);
      try{

        await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            "Content-Type" : "application/json",
            "Authorization" :
            "key=AAAAQdfQyzg:APA91bGNE_sbc4uEoDJ67oImR9fvu8bgDr9NwVwopWIDcqLi7t7isCAQPPVBOC_34QZd0I_agAqxQh-ChHaTS9xfhyR3k1BSJDapJ8KX78coAELxTkojUekJ6eSpQ7frwMKeoeRoBLsh"

          },
          body: jsonEncode(

            /// if i want to click on the notification and go to a page
            <String,dynamic>{
                'priority':'high',
                'data':<String,dynamic>{
                  'click_action':'FLUTTER_NOTIFICATION_CLICK',
                  'status' : 'done',
                  'body' : body,
                  'title' : title
                },

              'notification':<String,dynamic>{
                  "title":title,
                  "body" : body,
                  "android_channel_id" :"dbfood"
                },

              "to" : token,
            }
          ),

        );
      }
      catch(e){
        print("catch an error from sendPushMessage");
        print(e);
      }

  }

}