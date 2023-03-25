import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/firebase_auth_helper.dart';
import 'package:home_services_app/views/screens/account_page.dart';
import 'package:home_services_app/views/screens/admin/users_list.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  : 'User',
              style: GoogleFonts.habibi(fontSize: 18, color: Colors.black),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              prefs.remove('isAdmin');
              await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
              Get.offAndToNamed("/login_page");
            },
            icon: const Icon(Icons.power_settings_new),
          ),
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                                  Get.toNamed('/worker_details',
                                      arguments: documents[i]);
                                },
                                child: workerContainer(
                                    hourlyCharge: documents[i]['hourlyCharge'],
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
    const HomePage(),
    const UsersList(),
    const AccountPage(),
  ];

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      bottomNavBarItem(icon: const Icon(Icons.home), title: "Home"),
      bottomNavBarItem(icon: const Icon(Icons.list), title: "User List"),
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
