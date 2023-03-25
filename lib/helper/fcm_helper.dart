import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FCMHelper {
  FCMHelper._();
  static final FCMHelper fcmHelper = FCMHelper._();
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String API = "https://fcm.googleapis.com/fcm/send";
  String SERVER_KEY =
      "AAAAfGGgBAA:APA91bFSBsw9_1HJZebDd-3976kdmOYbZ6fN_JB7kSmiMtO-8rO5QI9a8jTB2NxC2lPAs0DSISBkbiYvrarTmEXT6NvGONcaH58VSbmtxXDWHYjAvxJ3_55nhPIgAZgA7C9mVqW-8FCy";

  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken(
      vapidKey:
          "BGQ6RAED9svRujR-FzDz_Ay9Az7TJrckkKtCMUkD0f3TCEDC3TlSf49nGdN68zcxqGndH1Fwrfcqo9hiZsE34GQ",
    );
    print(token);

    return token;
  }

  sendNotification(
      {required String title,
      required String body,
      required String? token}) async {
    Map<String, dynamic> data = {
      "to": token,
      "notification": {
        "content_available": true,
        "priority": "high",
        "title": title,
        "body": body,
      },
      "data": {
        "priority": "high",
        "content_available": true,
        "title": title,
        "body": body,
      }
    };

    await http.post(
      Uri.parse(API),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=$SERVER_KEY",
      },
    );
  }
}
