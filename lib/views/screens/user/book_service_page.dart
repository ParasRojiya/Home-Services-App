import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/cupertino.dart';
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
  List ratings = [];

  @override
  void initState() {
    super.initState();
    workerIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    Argument res = ModalRoute.of(context)!.settings.arguments as Argument;
    ratings = res.currentData['ratings'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        title: Text(
          "Book Service",
          style: GoogleFonts.habibi(),
        ),
        elevation: 5,
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 220,
                    width: Get.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/home-services-app-dd113.appspot.com/o/workers%2F360_F_307970377_gY9KgeQJs2U88vhV6S02YvwSMOStALVh.jpg?alt=media&token=96adf932-7b9a-4a5b-82bd-44cca81d961f'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            res.currentData['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              '₹ ${res.currentData['price']}',
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.center,
                              height: 27,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.indigo.shade50,
                              ),
                              child: Text(res.ids),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Duration : ${res.currentData['duration']} Minute',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Description : ",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "                              Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(
                          thickness: 0.5,
                        ),
                        DateTimePicker(
                          datePickerTitle: 'Select a Date',
                          timePickerTitle: 'Select a Time',
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
                            if (selectedTime.hour == 12 &&
                                selectedTime.minute == 0) {
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
                              time =
                                  "${selectedTime.hour}:${selectedTime.minute}0 AM";
                            } else {
                              time =
                                  "${selectedTime.hour}:${selectedTime.minute} AM";
                            }

                            hour = selectedTime.hour;
                            min = selectedTime.minute;
                          },
                          timeInterval: const Duration(minutes: 30),
                        ),
                        const SizedBox(height: 8),
                        const Divider(
                          thickness: 0.5,
                        ),
                        Container(
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: StreamBuilder(
                            stream: CloudFirestoreHelper.cloudFirestoreHelper
                                .fetchAllWorker(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot? document = snapshot.data;
                                List<QueryDocumentSnapshot>? documents =
                                    document!.docs;

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
                        Text(
                          "Rating & Reviews :",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 80 * ratings.length.toDouble(),
                          width: Get.width,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ratings.length,
                            itemBuilder: (context, i) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                ratings[i]['imageURL']),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${ratings[i]['name']}',
                                              style: GoogleFonts.habibi(
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${ratings[i]['review']}",
                                              style: GoogleFonts.habibi(
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 30,
                                        alignment: Alignment.center,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.indigo,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          '⭐ ${ratings[i]['rating']} ',
                                          style:
                                              GoogleFonts.ubuntu(fontSize: 15),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: Get.width,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: ElevatedButton(
                onPressed: () async {
                  int a = 0;
                  int b = 0;

                  if (categoryWorkers.isEmpty) {
                    Get.snackbar(
                        "Oops!", "Sorry workers not available for this service",
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
            )
          ],
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
      'serviceCategory': (res.ids == "z") ? "More" : res.ids,
      'servicePrice': res.currentData['price'],
      'desc': res.currentData['desc'],
      'imageURL': res.currentData['imageURL'],
      'duration': res.currentData['duration'],
      'SelectedDateTime': "$date $time",
      'workerName': availableWorkers[workerIndex]['name'],
      'workerNumber': availableWorkers[workerIndex]['number'],
      'rating': 0,
      'review': null,
    };

    List bookings = Global.currentUser!['bookings'];
    bookings.add(serviceData);

    Map<String, dynamic> data = {
      'bookings': bookings,
    };

    await CloudFirestoreHelper.cloudFirestoreHelper
        .updateUsersRecords(id: Global.currentUser!['email'], data: data);

    serviceData.remove('rating');
    serviceData.remove('review');
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
      'Duration': "${res.currentData['duration']}",
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
