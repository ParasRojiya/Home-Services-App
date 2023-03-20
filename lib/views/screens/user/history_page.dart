import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';

import '../../../global/global.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int index = 0;

  List pending = [];
  List ongoing = [];
  List completed = [];

  DateTime dateTime = DateTime.now();

  bool isProcessDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              CloudFirestoreHelper.cloudFirestoreHelper.selectUsersRecords(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot? document = snapshot.data;
              List<QueryDocumentSnapshot> documents = document!.docs;
              List bookings = [];
              for (var users in documents) {
                if (users.id == Global.currentUser!['email']) {
                  bookings = users['bookings'];
                }
              }

              pending.clear();
              completed.clear();
              ongoing.clear();

              for (Map book in bookings) {
                String fetchDateTime = book['SelectedDateTime'];
                String bookDate = fetchDateTime.split(' ').first;
                String bookTime = fetchDateTime.split(' ').elementAt(1);
                String period = fetchDateTime.split(' ').last;

                int date = int.parse(bookDate.split('-').first);
                int month = int.parse(bookDate.split('-').elementAt(1));

                double time =
                    getTimeOFService(bookTime: bookTime, period: period);

                double checkOnGoingTime = time + 1;

                if (month == dateTime.month &&
                    date == dateTime.day &&
                    dateTime.hour >= time &&
                    dateTime.hour <= checkOnGoingTime) {
                  ongoing.add(book);
                } else if (month < dateTime.month) {
                  completed.add(book);
                } else if (month == dateTime.month) {
                  if (date < dateTime.day) {
                    completed.add(book);
                  } else if (date == dateTime.day) {
                    if (time < dateTime.hour) {
                      completed.add(book);
                    } else {
                      pending.add(book);
                    }
                  } else {
                    pending.add(book);
                  }
                } else {
                  pending.add(book);
                }
              }

              return Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Text('pending'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Text('ongoing'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: Text('complete'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: index,
                      children: [
                        ListView.builder(
                          itemCount: pending.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                title: Text("${pending[i]['name']}"),
                                subtitle: Text("Rs. ${pending[i]['price']}"),
                                trailing:
                                    Text('${pending[i]['SelectedDateTime']}'),
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: ongoing.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                title: Text("${ongoing[i]['name']}"),
                                subtitle: Text("Rs. ${ongoing[i]['price']}"),
                                trailing:
                                    Text('${ongoing[i]['SelectedDateTime']}'),
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: completed.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                title: Text("${completed[i]['name']}"),
                                subtitle: Text("Rs. ${completed[i]['price']}"),
                                trailing:
                                    Text('${completed[i]['SelectedDateTime']}'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  getTimeOFService({required String bookTime, required String period}) {
    double time = 0;

    if (bookTime == '7:00' && period == 'AM') {
      time = 7;
    } else if (bookTime == '7:30' && period == 'AM') {
      time = 7.30;
    } else if (bookTime == '8:00' && period == 'AM') {
      time = 8;
    } else if (bookTime == '8:30' && period == 'AM') {
      time = 8.30;
    } else if (bookTime == '9:00' && period == 'AM') {
      time = 9;
    } else if (bookTime == '9:30' && period == 'AM') {
      time = 9.30;
    } else if (bookTime == '10:00' && period == 'AM') {
      time = 10;
    } else if (bookTime == '10:30' && period == 'AM') {
      time = 10.30;
    } else if (bookTime == '11:00' && period == 'AM') {
      time = 11;
    } else if (bookTime == '11:30' && period == 'AM') {
      time = 11.30;
    } else if (bookTime == '12:00' && period == 'PM') {
      time = 12;
    } else if (bookTime == '12:30' && period == 'PM') {
      time = 12.30;
    } else if (bookTime == '1:00' && period == 'PM') {
      time = 13;
    } else if (bookTime == '1:30' && period == 'PM') {
      time = 13.30;
    } else if (bookTime == '2:00' && period == 'PM') {
      time = 14;
    } else if (bookTime == '2:30' && period == 'PM') {
      time = 14.30;
    } else if (bookTime == '3:00' && period == 'PM') {
      time = 15;
    } else if (bookTime == '3:30' && period == 'PM') {
      time = 15.30;
    } else if (bookTime == '4:00' && period == 'PM') {
      time = 16;
    } else if (bookTime == '4:30' && period == 'PM') {
      time = 16.30;
    } else if (bookTime == '5:00' && period == 'PM') {
      time = 17;
    } else if (bookTime == '5:30' && period == 'PM') {
      time = 17.30;
    } else if (bookTime == '6:00' && period == 'PM') {
      time = 18;
    } else if (bookTime == '6:30' && period == 'PM') {
      time = 18.30;
    } else if (bookTime == '7:00' && period == 'PM') {
      time = 19;
    } else if (bookTime == '7:30' && period == 'PM') {
      time = 19.30;
    }
    return time;
  }
}
