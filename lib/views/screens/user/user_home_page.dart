import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/firebase_auth_helper.dart';
import 'package:home_services_app/views/screens/account_page.dart';
import 'package:home_services_app/views/screens/user/history_page.dart';
import 'package:home_services_app/views/screens/user/shop_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../../global/global.dart';
import '../../../helper/cloud_firestore_helper.dart';
import '../../../helper/local_notification_helper.dart';
import '../../../widgets/category_container.dart';
import '../../../widgets/nav_bar_item.dart';
import '../../../widgets/worker_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List color = [
    Colors.blue.withOpacity(0.1),
    Colors.green.withOpacity(0.1),
    Colors.indigo.withOpacity(0.1),
    Colors.orangeAccent.withOpacity(0.1),
    Colors.teal.withOpacity(0.1),
    Colors.grey.withOpacity(0.1),
  ];

  List banner = ['b-1.jpeg', 'b-2.jpeg', 'b-3.jpeg', 'b-4.jpeg', 'b-5.jpeg'];

  firebaseMessagingForegroundHandler(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.title}');
      print(message.notification?.body);
    }
    await LocalNotificationHelper.localNotificationHelper
        .sendSimpleNotification(
            title: message.notification!.title,
            msg: message.notification!.body);
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
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
              Get.offNamedUntil("/login_page", (route) => false);
              //   await FCMHelper.fcmHelper.getToken();
            },
            icon: const Icon(Icons.power_settings_new),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed('/chat_page',
                  arguments: Global.currentUser!['email']);
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
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const Icon(CupertinoIcons.search),
                    const SizedBox(width: 10),
                    Text(
                      'Search',
                      style: GoogleFonts.habibi(
                          fontSize: 17, color: Colors.black54),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayCurve: Curves.easeInOutExpo,
                  viewportFraction: 1,
                  height: 180.0,
                ),
                items: banner.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/images/$i'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
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
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  currentUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Global.user = FireBaseAuthHelper.firebaseAuth.currentUser;

    CloudFirestoreHelper.firebaseFirestore
        .collection('users')
        .doc(prefs.getString('currentUser'))
        .snapshots()
        .forEach((element) {
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
        'token': element.data()?['token'],
        'wallet': element.data()?['wallet'],
        'rate': element.data()?['rate'],
        'comment': element.data()?['comment'],
      };
    });
  }

  late PersistentTabController persistentTabController;

  firebaseMessagingForegroundHandler(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.title}');
      print(message.notification?.body);
    }
    await LocalNotificationHelper.localNotificationHelper
        .sendSimpleNotification(
            title: message.notification!.title,
            msg: message.notification!.body);
  }

  @override
  void initState() {
    super.initState();
    currentUserData();

    persistentTabController = PersistentTabController(initialIndex: 0);

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

    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print(
    //         'Message also contained a notification: ${message.notification!.title}');
    //     print(message.notification?.body);
    //   }
    //   await LocalNotificationHelper.localNotificationHelper
    //       .sendSimpleNotification(
    //           title: message.notification!.title,
    //           msg: message.notification!.body);
    // });

    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  }

  List<Widget> screens = [
    const HomePage(),
    const HistoryPage(),
    const ShopPage(),
    const AccountPage(),
  ];

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      bottomNavBarItem(icon: const Icon(CupertinoIcons.home), title: "Home"),
      bottomNavBarItem(
          icon: const Icon(CupertinoIcons.calendar), title: "Booking"),
      bottomNavBarItem(
          icon: const Icon(CupertinoIcons.shopping_cart), title: "Shopping"),
      bottomNavBarItem(
          icon: const Icon(CupertinoIcons.person), title: "Profile"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentUserData();
    });

    return WillPopScope(
      onWillPop: exitPopup,
      child: PersistentTabView(
        context,
        screens: screens,
        controller: persistentTabController,
        items: navBarItems(),
        hideNavigationBarWhenKeyboardShows: true,
        stateManagement: true,
        itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 300), curve: Curves.easeOutQuart),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.easeInCirc,
          duration: Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Future<bool> exitPopup() async {
    return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              color: Colors.grey.shade100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Container(
                height: 3,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Exit',
                style: GoogleFonts.balooBhai2(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.w500),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 3),
              Text(
                'Are you sure you want to exit?',
                style: GoogleFonts.balooBhai2(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 55,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade400,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.habibi(
                            fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      height: 55,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.indigo.shade400,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Exit',
                        style: GoogleFonts.habibi(
                            fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
