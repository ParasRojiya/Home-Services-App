import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../../global/global.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  int index = 0;
  PageController pageController = PageController();
  int initailTabIndex = 0;

  List pending = [];
  List ongoing = [];
  List completed = [];

  List data = [];
  List isOpen = [];
  List categoryServices = [];
  Map serviceMap = {};
  List bookings = [];

  List workerBookings = [];

  DateTime dateTime = DateTime.now();
  List<QueryDocumentSnapshot> documents = [];

  abcd() async {
    await CloudFirestoreHelper.cloudFirestoreHelper
        .selectUsersRecords()
        .forEach((element) {
      element.docs.forEach((element) {
        documents.add(element);
        print(element);
      });
    });
  }

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    abcd();
    data = pending;
    print("============================");
    print(documents);
    print("=============================");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookings",
          style: GoogleFonts.habibi(),
        ),
        centerTitle: true,
        bottom: TabBar(
          onTap: (val) {
            setState(
              () {
                tabController.animateTo(val);
                initailTabIndex = val;
                if (initailTabIndex == 0) {
                  data = pending;
                  leKachukoLe(documents: documents);

                  ongoing.clear();
                  completed.clear();
                } else if (initailTabIndex == 1) {
                  data = ongoing;
                  leKachukoLe(documents: documents);

                  pending.clear();
                  completed.clear();
                } else if (initailTabIndex == 2) {
                  data = completed;
                  leKachukoLe(documents: documents);
                  print(completed);

                  pending.clear();
                  ongoing.clear();
                }
              },
            );
          },
          controller: tabController,
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 2.5,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              child: Text(
                'Pending',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'OnGoing',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Completed',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectUsersRecords(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? document = snapshot.data;
            List<QueryDocumentSnapshot> documents = document!.docs;

            leKachukoLe(documents: documents);

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        isOpen[i] = !isOpen[i];
                      });
                    },
                    expandedHeaderPadding: const EdgeInsets.all(0),
                    elevation: 0,
                    children: <ExpansionPanel>[
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return Container(
                            height: 120,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Container(
                                  height: 105,
                                  width: 115,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(data[i]['imageURL']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      data[i]['serviceCategory'],
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      data[i]['serviceName'],
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.indigo),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹ ${data[i]['servicePrice']}',
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '4.3 ⭐   |    12 Review',
                                      style: GoogleFonts.poppins(fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    'Date',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    data[i]['SelectedDateTime']
                                        .split(' ')
                                        .first,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    'Time',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${data[i]['SelectedDateTime'].split(' ').elementAt(1)} ${data[i]['SelectedDateTime'].split(' ').last}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    'Duration',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${data[i]['duration']} Min',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    'Worker',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    data[i]['workerName'],
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    'Phone Number',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '+91 ${data[i]['workerNumber']}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Map<String, dynamic> receiptData = {
                                        'Name': Global.currentUser?['name'],
                                        'Service': data[i]['serviceName'],
                                        'Category': data[i]['serviceCategory'],
                                        'Duration': data[i]['duration'],
                                        'Date': data[i]['SelectedDateTime']
                                            .split(' ')
                                            .first,
                                        'Time':
                                            '${data[i]['SelectedDateTime'].split(' ').elementAt(1)} ${data[i]['SelectedDateTime'].split(' ').last}',
                                        'Price': data[i]['servicePrice'],
                                        'WorkerName': data[i]['workerName'],
                                        'WorkerNumber': data[i]['workerNumber'],
                                      };

                                      Get.toNamed('/service_receipt',
                                          arguments: receiptData);
                                    },
                                    child: Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      width: 240,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade300,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        'View Receipt',
                                        style: GoogleFonts.habibi(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  (pending.isNotEmpty)
                                      ? (data[i] == pending[i])
                                          ? TextButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Are you sure you want to cancel ${data[i]['serviceName']} service?"),
                                                        actions: [
                                                          OutlinedButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  "No")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                bookings.remove(
                                                                    data[i]);

                                                                Map<String,
                                                                        dynamic>
                                                                    deta = {
                                                                  'bookings':
                                                                      bookings,
                                                                };

                                                                CloudFirestoreHelper
                                                                    .cloudFirestoreHelper
                                                                    .updateUsersRecords(
                                                                        id: Global.currentUser![
                                                                            'email'],
                                                                        data:
                                                                            deta);

                                                                CloudFirestoreHelper
                                                                    .cloudFirestoreHelper
                                                                    .fetchAllWorker()
                                                                    .forEach(
                                                                        (element) {
                                                                  element.docs
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element
                                                                            .id ==
                                                                        data[i][
                                                                            'workerEmail']) {
                                                                      workerBookings.add(
                                                                          element[
                                                                              'bookings']);
                                                                    }
                                                                  });
                                                                });
                                                                print(
                                                                    "====================");
                                                                log("$workerBookings");
                                                                print(
                                                                    "====================");

                                                                workerBookings
                                                                    .remove(
                                                                        data[
                                                                            i]);

                                                                print(
                                                                    "----------------------");
                                                                log("$workerBookings");
                                                                print(
                                                                    "----------------------");
                                                                Map<String,
                                                                        dynamic>
                                                                    dete = {
                                                                  'bookings':
                                                                      workerBookings
                                                                };

                                                                await CloudFirestoreHelper
                                                                    .cloudFirestoreHelper
                                                                    .updateWorker(
                                                                        name: data[i]
                                                                            [
                                                                            'workerEmail'],
                                                                        data:
                                                                            dete);

                                                                Get.back();
                                                              },
                                                              child: const Text(
                                                                  "Yes")),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child:
                                                  const Text("Cancel Service"),
                                            )
                                          : Container()
                                      : (completed.isNotEmpty)
                                          ? (data[i] == completed[i])
                                              ? TextButton(
                                                  child: const Text(
                                                      "Rate & Review"),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (context) =>
                                                          RatingDialog(
                                                        initialRating:
                                                            completed[i]
                                                                    ['rating']
                                                                .toDouble(),
                                                        title: Text(
                                                          completed[i]
                                                              ['serviceName'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .blueAccent),
                                                        ),
                                                        message: const Text(
                                                          'Tap a star to set your rating',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                        image: Container(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          height: 150,
                                                          width: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(
                                                                  completed[i][
                                                                      'imageURL']),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        submitButtonText:
                                                            'Submit',
                                                        commentHint:
                                                            'Write a review(Optional)',
                                                        onCancelled: () =>
                                                            print('cancelled'),
                                                        onSubmitted:
                                                            (response) async {
                                                          if (response.rating >=
                                                              1) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Thank You For Your Feedback",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                textColor:
                                                                    Colors
                                                                        .black,
                                                                fontSize: 16.0);
                                                          }

                                                          int ind = 0;

                                                          for (int j = 0;
                                                              j <
                                                                  bookings
                                                                      .length;
                                                              j++) {
                                                            if (bookings[j] ==
                                                                data[i]) {
                                                              ind = j;
                                                            }
                                                          }

                                                          Map<String, dynamic>
                                                              element =
                                                              bookings[ind];

                                                          element.update(
                                                              "rating",
                                                              (value) =>
                                                                  response
                                                                      .rating);
                                                          element.update(
                                                              "review",
                                                              (value) =>
                                                                  response
                                                                      .comment);

                                                          bookings
                                                              .removeAt(ind);
                                                          bookings.insert(
                                                              ind, element);

                                                          Map<String, dynamic>
                                                              dete = {
                                                            'bookings':
                                                                bookings,
                                                          };

                                                          CloudFirestoreHelper
                                                              .cloudFirestoreHelper
                                                              .updateUsersRecords(
                                                                  id: Global
                                                                          .currentUser![
                                                                      'email'],
                                                                  data: dete);

                                                          rateAndReview(
                                                              i: i,
                                                              response:
                                                                  response);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container()
                                          : Container(),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        isExpanded: isOpen[i],
                        canTapOnHeader: true,
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
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

  leKachukoLe({required List<QueryDocumentSnapshot> documents}) {
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

      double time = getTimeOFService(bookTime: bookTime, period: period);

      double currentTime = 0;

      if (dateTime.minute > 30) {
        currentTime = dateTime.hour + 0.30;
      } else {
        currentTime = dateTime.hour.toDouble();
      }

      double duration = 0;

      if (book['duration'] == 30) {
        duration = 0.30;
      } else {
        duration = 1;
      }

      double checkOnGoingTime = time + duration;

      if (month == dateTime.month &&
          date == dateTime.day &&
          currentTime >= time &&
          currentTime <= checkOnGoingTime) {
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

    if (initailTabIndex == 0) {
      data = pending;
    } else if (initailTabIndex == 1) {
      data = ongoing;
    } else if (initailTabIndex == 2) {
      data = completed;
    }

    for (Map book in data) {
      bool isOpenPanel = false;
      isOpen.add(isOpenPanel);
    }
  }

  rateAndReview({required int i, required response}) async {
    CloudFirestoreHelper.cloudFirestoreHelper
        .fetchAllCategories()
        .forEach((element) {
      element.docs.forEach((element) {
        if (element.id == data[i]['serviceCategory']) {
          categoryServices = element['services'];
        }
      });
    });

    Map<String, dynamic> deta = {
      'imageURL': Global.currentUser!['imageURL'],
      'name': Global.currentUser!['name'],
      'rating': response.rating,
      'review': response.comment,
    };

    for (int j = 0; j < categoryServices.length; j++) {
      if (categoryServices[j]['name'] == data[i]['serviceName']) {
        serviceMap = categoryServices[j];
        categoryServices.removeAt(j);
      }
    }

    print("++++++++++++++++++++++++++++++++++++++++++++++++");
    print("$serviceMap");
    print("++++++++++++++++++++++++++++++++++++++++++++++++");
    List ratings = [];

    ratings = serviceMap['ratings'];
    print("--------------------------");
    print(ratings);
    print("--------------------------");
    ratings.add(deta);
    serviceMap.update('ratings', (value) => ratings);

    categoryServices.add(serviceMap);

    Map<String, dynamic> updatedService = {
      'services': categoryServices,
    };
    print("=============================");
    log("$updatedService");
    print("=============================");

    CloudFirestoreHelper.cloudFirestoreHelper
        .updateService(name: data[i]['serviceCategory'], data: updatedService);

    print("*******************************");
    print("$categoryServices");
    print("*******************************");
  }
}
