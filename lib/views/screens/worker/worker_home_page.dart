import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/global/global.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../../controllers/cart_controller.dart';
import '../../../helper/firebase_auth_helper.dart';
import '../../../helper/local_notification_helper.dart';
import '../../../widgets/category_container.dart';
import '../../../widgets/nav_bar_item.dart';
import '../../../widgets/worker_container.dart';
import '../account_page.dart';

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

  final CartController cartController = Get.put(CartController());

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
              prefs.remove('isWorker');
              await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
              Get.offNamedUntil("/login_page", (route) => false);
              //   await FCMHelper.fcmHelper.getToken();
            },
            icon: const Icon(Icons.power_settings_new),
          ),
          IconButton(
            onPressed: () {
              // Get.toNamed('/chats_page',
              //     arguments: Global.currentUser!['email']);
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

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({Key? key}) : super(key: key);

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
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
        'cart': element.data()?['cart'],
        'recentlyViewed': element.data()?['recentlyViewed'],
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
    const WorkerDashboard(),
    const HomePage(),
    // const HistoryPage(),
    const AccountPage(),
  ];

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      bottomNavBarItem(icon: const Icon(Icons.dashboard), title: "Dashboard"),
      bottomNavBarItem(icon: const Icon(CupertinoIcons.home), title: "Home"),
      // bottomNavBarItem(
      //     icon: const Icon(CupertinoIcons.calendar), title: "Booking"),
      // bottomNavBarItem(
      //     icon: const Icon(CupertinoIcons.shopping_cart), title: "Shopping"),
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

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({Key? key}) : super(key: key);

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  List bookingss = [];

  List pending = [];
  List ongoing = [];
  List completed = [];
  DateTime dateTime = DateTime.now();

  // final GraphController graphController = Get.put(GraphController());
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
              prefs.remove('isWorker');
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 140,
                    width: Get.width * 0.95,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff2C62FF).withOpacity(0.8)),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CloudFirestoreHelper.cloudFirestoreHelper
                          .fetchAllWorker(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot? document = snapshot.data;
                          List<QueryDocumentSnapshot> documents =
                              document!.docs;
                          List bookings = [];
                          for (var worker in documents) {
                            if (worker.id == Global.currentUser!['email']) {
                              bookings = worker['bookings'];
                              bookingss = worker['bookings'];
                            }
                          }

                          return InkWell(
                            onTap: () {
                              Get.toNamed('/bookings_page',
                                  arguments: bookings);
                              Global.title = "All Bookings";
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 35,
                                        margin: const EdgeInsets.only(
                                            bottom: 5, left: 3),
                                        width: 35,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/icon_booking.png'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${bookings.length}',
                                        style: GoogleFonts.gabriela(
                                          fontSize: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                  Text(
                                    'Total Bookings',
                                    style: GoogleFonts.habibi(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed('/bookings_page', arguments: pending);
                    Global.title = "Pending Bookings";
                  },
                  child: Container(
                    height: 140,
                    width: Get.width * 0.47,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffFBB41A)),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CloudFirestoreHelper.cloudFirestoreHelper
                          .fetchAllWorker(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot? document = snapshot.data;
                          List<QueryDocumentSnapshot> documents =
                              document!.docs;

                          leKachukoLe(documents: documents);

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
                                      '${pending.length}',
                                      style: GoogleFonts.gabriela(
                                        fontSize: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                                Text(
                                  'Pending',
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
                    Get.toNamed('/bookings_page', arguments: completed);
                    Global.title = "Completed Bookings";
                  },
                  child: Container(
                    height: 140,
                    width: Get.width * 0.47,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffFF5E5B)),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CloudFirestoreHelper.cloudFirestoreHelper
                          .fetchAllWorker(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          QuerySnapshot? document = snapshot.data;
                          List<QueryDocumentSnapshot> documents =
                              document!.docs;

                          leKachukoLe(documents: documents);

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
                                      '${completed.length}',
                                      style: GoogleFonts.gabriela(
                                        fontSize: 60,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                                Text(
                                  'Completed',
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
            const SizedBox(height: 25),
            StreamBuilder<QuerySnapshot>(
              stream:
                  CloudFirestoreHelper.cloudFirestoreHelper.fetchAllBookings(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  QuerySnapshot? document = snapshot.data;
                  List<QueryDocumentSnapshot> documentss = document!.docs;
                  List bookings = [];
                  for (var worker in documentss) {
                    if (worker.id == Global.currentUser!['email']) {
                      bookings = worker['bookings'];
                    }
                  }

                  List dummy = [];

                  double sun = 0;
                  double mon = 0;
                  double tue = 0;
                  double wed = 0;
                  double thu = 0;
                  double fri = 0;
                  double sat = 0;

                  for (int i = 0; i < bookingss.length; i++) {
                    String date =
                        bookingss[i]['SelectedDateTime'].split('-').first;
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

  leKachukoLe({required List<QueryDocumentSnapshot> documents}) {
    for (var users in documents) {
      if (users.id == Global.currentUser!['email']) {
        bookingss = users['bookings'];
      }
    }

    pending.clear();
    completed.clear();
    ongoing.clear();

    for (Map book in bookingss) {
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

class Counter {
  int x;
  double y;

  Counter({required this.x, required this.y});
}
