import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/global/button_syle.dart';
import 'package:home_services_app/views/screens/admin/all_services_page.dart';

import '../../../global/global.dart';
import '../../../global/snack_bar.dart';
import '../../../helper/cloud_firestore_helper.dart';

class BookService extends StatefulWidget {
  const BookService({Key? key}) : super(key: key);

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  Time _time = Time(hour: 11, minute: 30, second: 20);
  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  String? date, time;
  DateTime dt = DateTime.now();

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
                    print("=================================");
                    print(date);
                    print("=================================");
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
                  },
                  timeInterval: const Duration(minutes: 30),
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
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Booking Confirmation"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${res.currentData['name']}",
                                    style: GoogleFonts.ubuntu(),
                                  ),
                                  Text(
                                    "Price: ${res.currentData['price']}",
                                    style: GoogleFonts.ubuntu(),
                                  ),
                                  Text(
                                    "Duration: ${res.currentData['duration']}",
                                    style: GoogleFonts.ubuntu(),
                                  ),
                                  Text(
                                    "Date: $date",
                                    style: GoogleFonts.ubuntu(),
                                  ),
                                  Text(
                                    "Time: $time",
                                    style: GoogleFonts.ubuntu(),
                                  ),
                                ],
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Map<String, dynamic> serviceData = {
                                      'name': res.currentData['name'],
                                      'price': res.currentData['price'],
                                      'desc': res.currentData['desc'],
                                      'imageURL': res.currentData['imageURL'],
                                      'duration': res.currentData['duration'],
                                      'SelectedDateTime': "$date $time",
                                    };
                                    List bookings =
                                        Global.currentUser!['bookings'];
                                    bookings.add(serviceData);

                                    Map<String, dynamic> data = {
                                      'bookings': bookings,
                                    };

                                    await CloudFirestoreHelper
                                        .cloudFirestoreHelper
                                        .updateUsersRecords(
                                            id: Global.currentUser!['email'],
                                            data: data);

                                    await CloudFirestoreHelper
                                        .cloudFirestoreHelper
                                        .addServiceInBookingCollection(
                                            data: data,
                                            userEmail:
                                                Global.currentUser!['email']);
                                    print(
                                        "====================CURRENT USER UID===========================");
                                    print(Global.user!.email);
                                    print(
                                        "===============================================");
                                    print(
                                        "===============================================");
                                    print(
                                        "=====================CURRENT USER==========================");
                                    print(Global.currentUser);
                                    print(
                                        "===============================================");
                                    print(
                                        "=======================BOOKING SERVICE DATA========================");
                                    print(data);
                                    print(
                                        "===============================================");
                                    successSnackBar(
                                        msg:
                                            "Service successfully added in database",
                                        context: context);
                                    Get.offNamedUntil(
                                        '/user_home_page', (route) => false);
                                  },
                                  child: const Text("Book"),
                                ),
                              ],
                            );
                          });
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
