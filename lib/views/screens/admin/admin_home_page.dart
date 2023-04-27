import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/controllers/graph_controller.dart';
import 'package:home_services_app/helper/firebase_auth_helper.dart';
import 'package:home_services_app/views/screens/account_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../global/global.dart';
import '../../../helper/cloud_firestore_helper.dart';
import '../../../widgets/category_container.dart';
import '../../../widgets/nav_bar_item.dart';
import '../../../widgets/worker_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  currentUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Global.user = FireBaseAuthHelper.firebaseAuth.currentUser;

    await CloudFirestoreHelper.firebaseFirestore
        .collection('users')
        .doc(prefs.getString('currentUser'))
        .snapshots()
        .forEach((element) async {
      Global.currentUser = {
        'name': element.data()?['name'],
        'email': element.data()?['email'],
        'password': element.data()?['password'],
        'role': element.data()?['role'],
        'bookings': element.data()?['bookings'],
        'imageURL': element.data()?['imageURL'],
        'address': element.data()?['address'],
        'DOB': element.data()?['DOB'],
        'contact': element.data()?['contact'],
        'token': element.data()?['token']
      };
    });
  }

  List color = [
    Colors.blue.withOpacity(0.1),
    Colors.green.withOpacity(0.1),
    Colors.indigo.withOpacity(0.1),
    Colors.orangeAccent.withOpacity(0.1),
    Colors.teal.withOpacity(0.1),
    Colors.grey.withOpacity(0.1),
  ];

  @override
  void initState() {
    currentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome 👋',
              style:
                  GoogleFonts.habibi(fontSize: 15, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 2),
            Text(
              (Global.currentUser != null)
                  ? '${Global.currentUser!['name']}'
                  : (Global.isAdmin)
                      ? 'Admin'
                      : 'User',
              style: GoogleFonts.habibi(fontSize: 18, color: Colors.black),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/chats_page');
            },
            icon: const Icon(CupertinoIcons.captions_bubble),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: Column(
            children: [
              const SizedBox(height: 3),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Categories",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.toNamed("/all_categories_page");
                        },
                        style: TextButton.styleFrom(
                            textStyle: GoogleFonts.poppins()),
                        child: const Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 230,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CloudFirestoreHelper.cloudFirestoreHelper
                          .fetchAllCategories(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot? document = snapshot.data;
                          List<QueryDocumentSnapshot> documents =
                              document!.docs;

                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 110,
                            ),
                            itemCount:
                                (documents.length >= 6) ? 6 : documents.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  Get.toNamed('/all_services_page',
                                      arguments: documents[i]);
                                },
                                child: categoryContainer(
                                    categoryName: documents[i].id,
                                    color: color[i],
                                    imageURL: documents[i]['imageURL']),
                              );
                            },
                          );
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
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Workers",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.toNamed("/all_workers");
                        },
                        style: TextButton.styleFrom(
                            textStyle: GoogleFonts.poppins()),
                        child: const Text(
                          "View all",
                          style: TextStyle(fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 380,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CloudFirestoreHelper.cloudFirestoreHelper
                          .fetchAllWorker(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot? document = snapshot.data;
                          List<QueryDocumentSnapshot> documents =
                              document!.docs;

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                (documents.length >= 3) ? 3 : documents.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  (Global.isAdmin)
                                      ? Get.toNamed('/edit_worker',
                                          arguments: documents[i])
                                      : Get.toNamed('/worker_details',
                                          arguments: documents[i]);
                                },
                                child: workerContainer(
                                    name: documents[i]['name'],
                                    imageURL: documents[i]['imageURL'],
                                    number: documents[i]['number'],
                                    service: documents[i]['category']),
                              );
                            },
                          );
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
                ],
              ),
            ],
          ),
        ),
      ),
      // SingleChildScrollView(
      //   physics: const BouncingScrollPhysics(),
      //   child: Padding(
      //     padding: const EdgeInsets.all(12.0),
      //     child: Column(
      //       children: [
      //         Container(
      //           color: Colors.teal,
      //           height: 180,
      //           alignment: Alignment.center,
      //           child: const Text("Special Offers in Carousel Slider"),
      //         ),
      //         Column(
      //           children: [
      //             Row(
      //               children: [
      //                 Text(
      //                   "Categories",
      //                   style: GoogleFonts.poppins(
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ),
      //                 const Spacer(),
      //                 TextButton(
      //                   onPressed: () {
      //                     Get.toNamed("/all_categories_page");
      //                   },
      //                   style: TextButton.styleFrom(
      //                       textStyle: GoogleFonts.poppins()),
      //                   child: const Text("View all"),
      //                 )
      //               ],
      //             ),
      //             Container(
      //               height: 420,
      //               child: StreamBuilder<QuerySnapshot>(
      //                 stream: CloudFirestoreHelper.cloudFirestoreHelper
      //                     .fetchAllCategories(),
      //                 builder: (context, AsyncSnapshot snapshot) {
      //                   if (snapshot.hasData) {
      //                     QuerySnapshot? document = snapshot.data;
      //                     List<QueryDocumentSnapshot> documents =
      //                         document!.docs;
      //
      //                     return GridView.builder(
      //                       physics: const BouncingScrollPhysics(),
      //                       gridDelegate:
      //                           const SliverGridDelegateWithFixedCrossAxisCount(
      //                         crossAxisCount: 2,
      //                         mainAxisSpacing: 14,
      //                         crossAxisSpacing: 14,
      //                         mainAxisExtent: 200,
      //                       ),
      //                       itemCount:
      //                           (documents.length >= 4) ? 4 : documents.length,
      //                       itemBuilder: (context, i) {
      //                         return InkWell(
      //                           onTap: () {
      //                             Get.toNamed('/all_services_page',
      //                                 arguments: documents[i]);
      //                             print(documents[i]['services']);
      //                           },
      //                           child: categoryContainer(
      //                               categoryName: documents[i].id,
      //                               color: Colors.blue.withOpacity(0.1),
      //                               imageURL: documents[i]['imageURL']),
      //                         );
      //                       },
      //                     );
      //                   } else if (snapshot.hasError) {
      //                     return Center(
      //                       child: Text(
      //                         "Error: ${snapshot.error}",
      //                         style: GoogleFonts.poppins(),
      //                       ),
      //                     );
      //                   }
      //
      //                   return const Center(
      //                     child: CircularProgressIndicator(),
      //                   );
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //         Column(
      //           children: [
      //             Row(
      //               children: [
      //                 Text(
      //                   "Workers",
      //                   style: GoogleFonts.poppins(
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ),
      //                 const Spacer(),
      //                 TextButton(
      //                   onPressed: () {
      //                     Get.toNamed("/all_workers");
      //                   },
      //                   style: TextButton.styleFrom(
      //                       textStyle: GoogleFonts.poppins()),
      //                   child: const Text("View all"),
      //                 )
      //               ],
      //             ),
      //             Container(
      //               height: 420,
      //               child: StreamBuilder<QuerySnapshot>(
      //                 stream: CloudFirestoreHelper.cloudFirestoreHelper
      //                     .fetchAllWorker(),
      //                 builder: (context, AsyncSnapshot snapshot) {
      //                   if (snapshot.hasData) {
      //                     QuerySnapshot? document = snapshot.data;
      //                     List<QueryDocumentSnapshot> documents =
      //                         document!.docs;
      //
      //                     return GridView.builder(
      //                       physics: const BouncingScrollPhysics(),
      //                       gridDelegate:
      //                           const SliverGridDelegateWithFixedCrossAxisCount(
      //                         crossAxisCount: 2,
      //                         mainAxisSpacing: 14,
      //                         crossAxisSpacing: 14,
      //                         mainAxisExtent: 225,
      //                       ),
      //                       itemCount:
      //                           (documents.length >= 4) ? 4 : documents.length,
      //                       itemBuilder: (context, i) {
      //                         return InkWell(
      //                           onTap: () {
      //                             Get.toNamed('/edit_worker',
      //                                 arguments: documents[i]);
      //                           },
      //                           child: workerContainer(
      //                               hourlyCharge: documents[i]['hourlyCharge'],
      //                               name: documents[i]['name'],
      //                               number: documents[i]['number'],
      //                               imageURL: documents[i]['imageURL'],
      //                               service: documents[i]['category']),
      //                         );
      //                       },
      //                     );
      //                   } else if (snapshot.hasError) {
      //                     return Center(
      //                       child: Text(
      //                         "Error: ${snapshot.error}",
      //                         style: GoogleFonts.poppins(),
      //                       ),
      //                     );
      //                   }
      //
      //                   return const Center(
      //                     child: CircularProgressIndicator(),
      //                   );
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

class Counter {
  int x;
  double y;

  Counter({required this.x, required this.y});
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GraphController graphController = Get.put(GraphController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin's Dasboard",
          style: GoogleFonts.habibi(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed('/all_categories_page');
                    },
                    child: Container(
                      height: 130,
                      width: Get.width * 0.47,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff2C62FF).withOpacity(0.8)),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: CloudFirestoreHelper.cloudFirestoreHelper
                            .fetchAllCategories(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot? document = snapshot.data;
                            List<QueryDocumentSnapshot> documents =
                                document!.docs;

                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        margin:
                                            EdgeInsets.only(bottom: 5, left: 3),
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/icon_category.png'),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${documents.length}',
                                        style: GoogleFonts.gabriela(
                                          fontSize: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                  Text(
                                    'Category',
                                    style: GoogleFonts.habibi(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            );
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
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed('/all_workers');
                    },
                    child: Container(
                      height: 130,
                      width: Get.width * 0.47,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(
                          //   width: 1,
                          //   color: Colors.black,
                          // ),
                          color: const Color(0xff2BC999)),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: CloudFirestoreHelper.cloudFirestoreHelper
                            .fetchAllWorker(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot? document = snapshot.data;
                            List<QueryDocumentSnapshot> documents =
                                document!.docs;

                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        margin:
                                            EdgeInsets.only(bottom: 5, left: 3),
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/icon_worker.png'),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${documents.length}',
                                        style: GoogleFonts.gabriela(
                                          fontSize: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                  Text(
                                    'Worker',
                                    style: GoogleFonts.habibi(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            );
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
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed('/users_list');
                    },
                    child: Container(
                      height: 130,
                      width: Get.width * 0.47,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffFBB41A),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: CloudFirestoreHelper.cloudFirestoreHelper
                            .selectUsersRecords(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot? document = snapshot.data;
                            List<QueryDocumentSnapshot> documents =
                                document!.docs;

                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        margin:
                                            EdgeInsets.only(bottom: 5, left: 3),
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/icon_user.png'),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${documents.length}',
                                        style: GoogleFonts.gabriela(
                                          fontSize: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                  Text(
                                    'User',
                                    style: GoogleFonts.habibi(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            );
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
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed('/all_bookings');
                    },
                    child: Container(
                      height: 130,
                      width: Get.width * 0.47,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffFF5E5B),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: CloudFirestoreHelper.cloudFirestoreHelper
                            .fetchAllBookings(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot? document = snapshot.data;
                            List<QueryDocumentSnapshot> documents =
                                document!.docs;

                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 30,
                                        margin: const EdgeInsets.only(
                                            bottom: 5, left: 3),
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/icon_booking.png'),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${documents.length}',
                                        style: GoogleFonts.gabriela(
                                          fontSize: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                  Text(
                                    'Bookings',
                                    style: GoogleFonts.habibi(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            );
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
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: CloudFirestoreHelper.cloudFirestoreHelper
                    .fetchAllBookings(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot? document = snapshot.data;
                    List<QueryDocumentSnapshot> documents = document!.docs;

                    List dummy = [];

                    double sun = 0;
                    double mon = 0;
                    double tue = 0;
                    double wed = 0;
                    double thu = 0;
                    double fri = 0;
                    double sat = 0;

                    for (int i = 0; i < documents.length; i++) {
                      String date =
                          documents[i]['SelectedDateTime'].split('-').first;
                      if (23 == int.parse(date)) {
                        sun++;
                      } else if (24 == int.parse(date)) {
                        mon++;
                      } else if (25 == int.parse(date)) {
                        tue++;
                      } else if (26 == int.parse(date)) {
                        wed++;
                      } else if (27 == int.parse(date)) {
                        thu++;
                      } else if (28 == int.parse(date)) {
                        fri++;
                      } else if (29 == int.parse(date)) {
                        sat++;
                      }
                    }

                    dummy = [
                      Counter(x: 23, y: sun),
                      Counter(x: 24, y: mon),
                      Counter(x: 25, y: tue),
                      Counter(x: 26, y: wed),
                      Counter(x: 27, y: thu),
                      Counter(x: 28, y: fri),
                      Counter(x: 29, y: sat),
                    ];

                    return SizedBox(
                        height: 350,
                        width: Get.width,
                        child: BarChart(
                            swapAnimationCurve: Curves.bounceInOut,
                            swapAnimationDuration: const Duration(seconds: 5),
                            BarChartData(
                              minY: 0,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.white,
                                ),
                              ),
                              maxY: 10,
                              backgroundColor: Colors.grey.shade200,
                              gridData: FlGridData(
                                drawHorizontalLine: true,
                                show: true,
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                show: true,
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 33,
                                    getTitlesWidget: getTitle,
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 2,
                                      reservedSize: 30),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 33,
                                    getTitlesWidget: getBottomTitle,
                                  ),
                                ),
                              ),
                              barGroups: dummy
                                  .map(
                                    (e) => BarChartGroupData(
                                      x: e.x,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.y,
                                          color: Colors.grey[800],
                                          width: 30,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            )));
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
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitle(double x, TitleMeta meta) {
    Widget text;
    if (x == 26) {
      text = Text(
        'Weekly Booking Report',
        style: GoogleFonts.habibi(fontSize: 18),
      );
    } else {
      text = const Text('');
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget getBottomTitle(double x, TitleMeta meta) {
    Widget text;
    if (x == 23) {
      text = Text(
        'S',
        style: GoogleFonts.habibi(fontSize: 16),
      );
    } else if (x == 24) {
      text = Text(
        'M',
        style: GoogleFonts.habibi(fontSize: 16),
      );
    } else if (x == 25) {
      text = Text(
        'T',
        style: GoogleFonts.habibi(fontSize: 16),
      );
    } else if (x == 26) {
      text = Text(
        'W',
        style: GoogleFonts.habibi(fontSize: 16),
      );
    } else if (x == 27) {
      text = Text(
        'T',
        style: GoogleFonts.habibi(fontSize: 16),
      );
    } else if (x == 28) {
      text = Text(
        'F',
        style: GoogleFonts.habibi(fontSize: 16),
      );
    } else {
      text = Text(
        'S',
        style: GoogleFonts.habibi(fontSize: 16),
      );
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late PersistentTabController persistentTabController;

  @override
  void initState() {
    super.initState();
    persistentTabController = PersistentTabController(initialIndex: 0);
  }

  List<Widget> screens = [
    const AdminDashboard(),
    const HomePage(),
    const AccountPage(),
  ];

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      bottomNavBarItem(icon: const Icon(Icons.dashboard), title: "Dashboard"),
      bottomNavBarItem(icon: const Icon(Icons.home), title: "Home"),
      bottomNavBarItem(
          icon: const Icon(Icons.account_circle), title: "Account"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: screens,
      controller: persistentTabController,
      items: navBarItems(),
      hideNavigationBarWhenKeyboardShows: true,
      stateManagement: true,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 300),
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        duration: Duration(milliseconds: 300),
      ),
    );
  }
}
