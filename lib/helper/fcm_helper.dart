import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FCMHelper {
  FCMHelper._();
  static final FCMHelper fcmHelper = FCMHelper._();
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String API = "https://fcm.googleapis.com/fcm/send";
  String SERVER_KEY =
      "YOUR_SERVER_KEY";

  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken(
      vapidKey:
          "KEY",
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
