import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/views/screens/admin/all_services_page.dart';

import '../../../global/button_syle.dart';
import '../../../global/global.dart';
import '../../../global/snack_bar.dart';
import '../../../helper/cloud_firestore_helper.dart';
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

  late int workerIndex;
  List categoryWorkers = [];
  List availableWorkers = [];
  List workerBookings = [];
  List finalWorkers = [];

  @override
  void initState() {
    super.initState();
    workerIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    Argument res = ModalRoute.of(context)!.settings.arguments as Argument;
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Service"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Text("${res.currentData['duration']}"),
              DateTimePicker(
                initialSelectedDate: (dt.hour < 20)
                    ? dt
                    : DateTime(dt.year, dt.month, dt.day + 1, 8),
                startTime: (dt.hour < 20)
                    ? DateTime(dt.year, dt.month, dt.day, 8)
                    : DateTime(dt.year, dt.month, dt.day + 1, 8),
                endTime: (dt.hour < 20)
                    ? DateTime(dt.year, dt.month, dt.day, 20)
                    : DateTime(dt.year, dt.month, dt.day + 1, 20),
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
              const SizedBox(height: 20),
              Container(
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: StreamBuilder(
                  stream: CloudFirestoreHelper.cloudFirestoreHelper
                      .fetchAllWorker(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot? document = snapshot.data;
                      List<QueryDocumentSnapshot>? documents = document!.docs;

                      for (var worker in documents) {
                        if (worker['category'] == res.fullData.id) {
                          categoryWorkers.add(worker);
                        }
                      }
                      print(categoryWorkers);

                      return Container();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    int a = 0;
                    int b = 0;

                    if (categoryWorkers.isEmpty) {
                      Get.snackbar("Oops!",
                          "Sorry workers not available for this service",
                          backgroundColor: Colors.red);
                    } else {
                      for (int i = 0; i < categoryWorkers.length; i++) {
                        List data = categoryWorkers[i]['bookings'];
                        a = data.length;

                        if (data.isEmpty) {
                          availableWorkers.add(categoryWorkers[i]);
                          //  bookService(res: res);
                        } else {
                          for (int j = 0; j < data.length; j++) {
                            Map tada = data[j];
                            if (tada['SelectedDateTime'] != "$date $time") {
                              b++;
                            }
                          }
                          if (a == b) {
                            availableWorkers.add(categoryWorkers[i]);
                          }
                        }
                        b = 0;
                      }

                      if (availableWorkers.isNotEmpty) {
                        bookService(res: res);
                      } else {
                        Get.snackbar("Oops!",
                            "Sorry workers not available for this time slot");
                      }
                    }
                  },
                  style: elevatedButtonStyle(),
                  child: const Text("Book Service"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  bookService({required Argument res}) async {
    workerIndex = Random().nextInt(availableWorkers.length);
    workerBookings = availableWorkers[workerIndex]['bookings'];

    Map<String, dynamic> serviceData = {
      'customerName': Global.currentUser!['name'],
      'customerNumber': Global.currentUser!['contact'],
      'serviceName': res.currentData['name'],
      'serviceCategory': res.currentData['name'],
      'servicePrice': res.currentData['price'],
      'desc': res.currentData['desc'],
      'imageURL': res.currentData['imageURL'],
      'duration': res.currentData['duration'],
      'SelectedDateTime': "$date $time",
      'workerName': availableWorkers[workerIndex]['name'],
      'workerNumber': availableWorkers[workerIndex]['number'],
    };

    List bookings = Global.currentUser!['bookings'];
    bookings.add(serviceData);

    Map<String, dynamic> data = {
      'bookings': bookings,
    };

    await CloudFirestoreHelper.cloudFirestoreHelper
        .updateUsersRecords(id: Global.currentUser!['email'], data: data);

    await CloudFirestoreHelper.cloudFirestoreHelper
        .addServiceInBookingCollection(
            data: data, userEmail: Global.currentUser!['email']);

    workerBookings.add(serviceData);
    Map<String, dynamic> workerData = {
      'bookings': workerBookings,
    };

    await CloudFirestoreHelper.cloudFirestoreHelper.updateWorker(
        name: availableWorkers[workerIndex]['email'], data: workerData);

    Map<String, dynamic> receiptData = {
      'Name': Global.currentUser?['name'],
      'Service': res.currentData['name'],
      'Category': res.ids,
      'Duration': "${res.currentData['duration']} Hr",
      'Date': date,
      'Time': time,
      'Price': res.currentData['price'],
      'WorkerName': availableWorkers[workerIndex]['name'],
      'WorkerNumber': availableWorkers[workerIndex]['number'],
    };

    await LocalNotificationHelper.localNotificationHelper.sendSimpleNotification(
        title: res.currentData['name'],
        msg:
            "${res.currentData['name']} successfully booked for Rs.${res.currentData['price']} on $time $date");

    DateTime start = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    DateTime end = DateTime(year!, month!, day!, hour!, min!);

    DateTimeRange dtRange = DateTimeRange(start: start, end: end);

    print(dtRange.duration);

    await LocalNotificationHelper.localNotificationHelper.scheduledNotification(
        title: res.currentData['name'],
        body: "${res.currentData['name']} has started",
        duration: dtRange.duration);

    successSnackBar(
        msg: "Service successfully added in database", context: context);

    Get.toNamed('/service_receipt', arguments: receiptData);
  }
}
