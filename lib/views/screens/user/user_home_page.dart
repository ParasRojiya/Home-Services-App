import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/firebase_auth_helper.dart';
import 'package:home_services_app/views/screens/account_page.dart';
import 'package:home_services_app/views/screens/user/history_page.dart';
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
      };
    });
  }

  @override
  void initState() {
    currentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Dashboard"),
        centerTitle: true,
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
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                color: Colors.teal,
                height: 180,
                alignment: Alignment.center,
                child: const Text("Special Offers in Carousel Slider"),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Categories",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.toNamed("/all_categories_page");
                        },
                        style: TextButton.styleFrom(
                            textStyle: GoogleFonts.poppins()),
                        child: const Text("View all"),
                      )
                    ],
                  ),
                  Container(
                    height: 420,
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
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              mainAxisExtent: 200,
                            ),
                            itemCount:
                                (documents.length >= 4) ? 4 : documents.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  Get.toNamed('/all_services_page',
                                      arguments: documents[i]);
                                  print(documents[i]['services']);
                                },
                                child: categoryContainer(
                                    categoryName: documents[i].id,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.toNamed("/all_workers");
                        },
                        style: TextButton.styleFrom(
                            textStyle: GoogleFonts.poppins()),
                        child: const Text("View all"),
                      )
                    ],
                  ),
                  Container(
                    height: 470,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CloudFirestoreHelper.cloudFirestoreHelper
                          .fetchAllWorker(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot? document = snapshot.data;
                          List<QueryDocumentSnapshot> documents =
                              document!.docs;

                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              mainAxisExtent: 225,
                            ),
                            itemCount:
                                (documents.length >= 4) ? 4 : documents.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  Get.toNamed('/worker_details',
                                      arguments: documents[i]);
                                },
                                child: workerContainer(
                                  ratings: "⭐⭐⭐⭐⭐",
                                  rate: documents[i]['price'],
                                  name: documents[i]['name'],
                                  experience: documents[i]['experience'],
                                  imageURL: documents[i]['imageURL'],
                                ),
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
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late PersistentTabController persistentTabController;

  @override
  void initState() {
    super.initState();
    persistentTabController = PersistentTabController(initialIndex: 0);
  }

  List<Widget> screens = [
    const HomePage(),
    const HistoryPage(),
    const AccountPage(),
  ];

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      bottomNavBarItem(icon: const Icon(Icons.home), title: "Home"),
      bottomNavBarItem(icon: const Icon(Icons.shopping_cart), title: "Cart"),
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
