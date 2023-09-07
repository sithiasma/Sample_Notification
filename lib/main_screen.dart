// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sample_notification/button_widget.dart';
import 'package:sample_notification/form_textfield_widget.dart';
import 'package:sample_notification/form_title_widget.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? fcmtoken = "";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  List<String> LISTUSER = [];

  @override
  void initState() {
    super.initState();
    _fetchToken();
    requestPermission();
    getToken();
    initInfo();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      // iOS: iOSInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {}
      } catch (e) {}
      return;
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(".......onMessage.......");

      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood', 'dbfood', importance: Importance.high,

        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound:
            true, // sound: RowResourceAndroidNotificationSound('notification'),
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: const IOSNotificationDetails()); // NotificationDetails

      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        fcmtoken = token;
        print(" This is my token- $fcmtoken");
      });
      saveToken();
    });
  }

  void saveToken() async {
    await FirebaseFirestore.instance.collection("UserTokens").doc().set({
      'token': fcmtoken,
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      provisional: false,
      criticalAlert: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void sendPushMessage(String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAStfBYlw:APA91bFdVlowmMli95g0pt8TnXAP2rJxaixXcuMYo8OfcU8uv_fKdRDh5w4FqnXFrQ1c9SAKfpzwr8M9UvCZmktgbZ-O8t-p79o2SFofUeYfLfasWMHWyt9JeAwT7nhvbDz7byowZAOd',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'title': title,
              'body': body,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "dbfood"
            },
            'registration_ids': LISTUSER,
            // [
            //   "cAL6dyr-SBmvuwaK1rx6v8:APA91bEQSex5esjpqKKn0WCLdNMjS7X7QhTQQSbjtMN3PGIQGsx4ii6VYWKkV7TG-UYMnFrloBmgHrWKoFC3XOynx_pVDLzb0m8DbHzjCnVUtR19n249QUn-a0anCLndpsIdK4xf8IZn",
            //   "fTEMCo-DRd6-xoy3KRoTDx:APA91bHowASshW6iO-liHkDdZayeB8O24b65SZg2lQO4dBdjQnrJJp9nstj_q-ZA1p2GezrKCSYubyjvtcN2QQYAIaCujPkKPH-UhwOZFve6DfuMqW3_rIMcCSCkL5TuFWQBgsKQEBP4"
            // ],
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }

  void _fetchToken() async {
    var collection = FirebaseFirestore.instance.collection('Users');
    var docSnapshot = await collection.doc('Token').get();
    if (docSnapshot.exists) {
      List<String> data = List.castFrom(docSnapshot.get('list') as List);
      setState(() {
        LISTUSER = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextFieldLabel(title: 'Username'),
            // FormTextFieldWidget(
            //   avatar: '',
            //   controller: username,
            //   inputType: TextInputType.text,
            //   placeholder: 'username',
            // ),
            TextFieldLabel(title: 'Notification Title'),
            FormTextFieldWidget(
              avatar: '',
              controller: title,
              inputType: TextInputType.text,
              placeholder: 'Enter Notification Title',
            ),
            TextFieldLabel(title: 'Notification Body'),
            FormTextFieldWidget(
              avatar: '',
              controller: body,
              inputType: TextInputType.text,
              placeholder: 'Enter Notification Body ',
            ),
            ButtonWidget(
                bgColor: Colors.pinkAccent,
                title: "Submit",
                buttonColor: Colors.white,
                onTap: () async {
                  String name = username.text.trim();
                  String titleText = title.text;
                  String bodyText = body.text;

                  // if (name == '') {
                  //   await FirebaseFirestore.instance
                  //       .collection("Users")
                  //       .doc("Token")
                  //       .get()
                  //       .then(
                  //     (value) {
                  //       List<String> data = value['list'];
                  //       setState(() {
                  //         LISTUSER = data;
                  //       });
                  //     },
                  //   );

                  // String token = snap['token'];
                  print("pppppppp---$LISTUSER");

                  sendPushMessage(bodyText, titleText);
                  // }
                })
          ],
        ),
      ),
    );
  }
}
