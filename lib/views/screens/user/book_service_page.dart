import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/global/button_syle.dart';
import 'package:home_services_app/views/screens/admin/all_services_page.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../../global/global.dart';
import '../../../global/snack_bar.dart';
import '../../../helper/local_notification_helper.dart';

class BookService extends StatefulWidget {
  const BookService({Key? key}) : super(key: key);

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  String? date, time;
  DateTime dt = DateTime.now();
  int? year;
  int? month;
  int? day;
  int? hour;
  int? min;

  @override
  void initState() {
    print(Global.currentUser);

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    tz.initializeTimeZones();

    LocalNotificationHelper.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Argument res = ModalRoute.of(context)!.settings.arguments as Argument;
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Service"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(res.currentData['imageURL']),
                  radius: 65,
                ),
                const SizedBox(height: 12),
                Text(res.currentData['name']),
                const SizedBox(height: 12),
                Text("${res.currentData['price']} Rs."),
                const SizedBox(height: 12),
                Text(res.currentData['desc']),
                const SizedBox(height: 12),
                Text(res.currentData['duration']),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DateTimePicker(
                  initialSelectedDate: dt,
                  startTime: DateTime(dt.year, dt.month, dt.day, 8),
                  endTime: DateTime(dt.year, dt.month, dt.day, 20),
                  type: DateTimePickerType.Both,
                  is24h: false,
                  onDateChanged: (selectedDate) {
                    date =
                        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                    year = selectedDate.year;
                    month = selectedDate.month;
                    day = selectedDate.day;
                  },
                  onTimeChanged: (selectedTime) {
                    if (selectedTime.hour == 12 && selectedTime.minute == 0) {
                      time = "12:00 PM";
                    } else if (selectedTime.hour == 12 &&
                        selectedTime.minute == 30) {
                      time = "12:30 PM";
                    } else if (selectedTime.hour == 13 &&
                        selectedTime.minute == 0) {
                      time = "1:00 PM";
                    } else if (selectedTime.hour == 13 &&
                        selectedTime.minute == 30) {
                      time = "1:30 PM";
                    } else if (selectedTime.hour == 14 &&
                        selectedTime.minute == 0) {
                      time = "2:00 PM";
                    } else if (selectedTime.hour == 14 &&
                        selectedTime.minute == 30) {
                      time = "2:30 PM";
                    } else if (selectedTime.hour == 15 &&
                        selectedTime.minute == 0) {
                      time = "3:00 PM";
                    } else if (selectedTime.hour == 15 &&
                        selectedTime.minute == 30) {
                      time = "3:30 PM";
                    } else if (selectedTime.hour == 16 &&
                        selectedTime.minute == 0) {
                      time = "4:00 PM";
                    } else if (selectedTime.hour == 16 &&
                        selectedTime.minute == 30) {
                      time = "4:30 PM";
                    } else if (selectedTime.hour == 17 &&
                        selectedTime.minute == 0) {
                      time = "5:00 PM";
                    } else if (selectedTime.hour == 17 &&
                        selectedTime.minute == 30) {
                      time = "5:30 PM";
                    } else if (selectedTime.hour == 18 &&
                        selectedTime.minute == 0) {
                      time = "6:00 PM";
                    } else if (selectedTime.hour == 18 &&
                        selectedTime.minute == 30) {
                      time = "6:30 PM";
                    } else if (selectedTime.hour == 19 &&
                        selectedTime.minute == 0) {
                      time = "7:00 PM";
                    } else if (selectedTime.hour == 19 &&
                        selectedTime.minute == 30) {
                      time = "7:30 PM";
                    } else if (selectedTime.hour == 20 &&
                        selectedTime.minute == 0) {
                      time = "8:00 PM";
                    } else if (selectedTime.hour < 12 &&
                        selectedTime.minute != 30) {
                      time = "${selectedTime.hour}:${selectedTime.minute}0 AM";
                    } else {
                      time = "${selectedTime.hour}:${selectedTime.minute} AM";
                    }

                    hour = selectedTime.hour;
                    min = selectedTime.minute;
                  },
                  timeInterval: const Duration(minutes: 1),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "NOTE:- You can book services between 8:00 AM to 8:00 PM only.",
                    style: GoogleFonts.ubuntu(),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: Get.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: const Text("Booking Confirmation"),
                      //         content: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Text(
                      //               "${res.currentData['name']}",
                      //               style: GoogleFonts.ubuntu(),
                      //             ),
                      //             Text(
                      //               "Price: ${res.currentData['price']}",
                      //               style: GoogleFonts.ubuntu(),
                      //             ),
                      //             Text(
                      //               "Duration: ${res.currentData['duration']}",
                      //               style: GoogleFonts.ubuntu(),
                      //             ),
                      //             Text(
                      //               "Date: $date",
                      //               style: GoogleFonts.ubuntu(),
                      //             ),
                      //             Text(
                      //               "Time: $time",
                      //               style: GoogleFonts.ubuntu(),
                      //             ),
                      //           ],
                      //         ),
                      //         actions: [
                      //           OutlinedButton(
                      //             onPressed: () {
                      //               Get.back();
                      //             },
                      //             child: const Text("Cancel"),
                      //           ),
                      //           ElevatedButton(
                      //             onPressed: () async {
                      //
                      //               List bookings =
                      //                   Global.currentUser!['bookings'];
                      //               bookings.add(serviceData);
                      //
                      //               Map<String, dynamic> data = {
                      //                 'bookings': bookings,
                      //               };
                      //
                      //               await CloudFirestoreHelper
                      //                   .cloudFirestoreHelper
                      //                   .updateUsersRecords(
                      //                       id: Global.currentUser!['email'],
                      //                       data: data);
                      //
                      //               await CloudFirestoreHelper
                      //                   .cloudFirestoreHelper
                      //                   .addServiceInBookingCollection(
                      //                       data: data,
                      //                       userEmail:
                      //                           Global.currentUser!['email']);
                      //
                      //               // successSnackBar(
                      //               //     msg:
                      //               //     "Service successfully added in database",
                      //               //     context: context);
                      //
                      //               Get.snackbar("Service Booked Successfully",
                      //                   "Service");
                      //
                      //               Get.offNamedUntil(
                      //                   '/user_home_page', (route) => false);
                      //             },
                      //             child: const Text("Book"),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //
                      //
                      // );

                      successSnackBar(
                          msg: "Service successfully added in database",
                          context: context);

                      Map<String, dynamic> serviceData = {
                        'name': res.currentData['name'],
                        'price': res.currentData['price'],
                        'desc': res.currentData['desc'],
                        'imageURL': res.currentData['imageURL'],
                        'duration': res.currentData['duration'],
                        'SelectedDateTime': "$date $time",
                      };

                      List bookings = Global.currentUser!['bookings'];
                      bookings.add(serviceData);

                      Map<String, dynamic> data = {
                        'bookings': bookings,
                      };

                      // await CloudFirestoreHelper.cloudFirestoreHelper
                      //     .updateUsersRecords(
                      //         id: Global.currentUser!['email'], data: data);
                      //
                      // await CloudFirestoreHelper.cloudFirestoreHelper
                      //     .addServiceInBookingCollection(
                      //         data: data,
                      //         userEmail: Global.currentUser!['email']);

                      Map<String, dynamic> receiptData = {
                        'Name': Global.currentUser?['name'],
                        'Service': res.currentData['name'],
                        'Category': res.ids,
                        'Duration': "${res.currentData['duration']} Hr",
                        'Date': date,
                        'Time': time,
                        'Price': res.currentData['price'],
                        'Image': res.currentData['imageURL'],
                      };

                      await LocalNotificationHelper.localNotificationHelper
                          .sendSimpleNotification(
                              title: res.currentData['name'],
                              msg:
                                  "${res.currentData['name']} successfully booked for Rs.${res.currentData['price']} on $time $date");

                      DateTime start = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          DateTime.now().hour,
                          DateTime.now().minute);
                      DateTime end = DateTime(year!, month!, day!, hour!, min!);

                      DateTimeRange dtRange =
                          DateTimeRange(start: start, end: end);

                      print(dtRange.duration);

                      await LocalNotificationHelper.localNotificationHelper
                          .scheduledNotification(
                              title: res.currentData['name'],
                              body: "${res.currentData['name']} has started",
                              duration: dtRange.duration);

                      // Get.toNamed('/service_receipt', arguments: receiptData);
                    },
                    style: elevatedButtonStyle(),
                    child: const Text("Book Service"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
