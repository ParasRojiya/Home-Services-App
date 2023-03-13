// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
// class LocalNotificationHelper {
//
//   LocalNotificationHelper._();
//
//   static final LocalNotificationHelper localNotificationHelper = LocalNotificationHelper
//       ._();
//
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   sendSimpleNotification() async {
//     AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
//         'demo', 'demo_channel', 'message', priority: Priority.max,
//         importance: Importance.max);
//
//     IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails();
//
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: iosNotificationDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//         1, 'title', 'body', notificationDetails, payload: 'Custom Data');
//   }
//
//
// }
