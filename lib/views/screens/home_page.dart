import 'package:flutter/material.dart';
import 'package:home_services_app/helper/firebase_auth_helper.dart';
import 'package:get/get.dart';
import 'package:home_services_app/views/screens/account_page.dart';
import 'package:home_services_app/views/screens/history_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/global.dart';
import '../../widgets/category_container.dart';
import '../../widgets/nav_bar_item.dart';
import '../../widgets/worker_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Global.isAdmin)
            ? const Text("Admin Dashboard")
            : const Text("User Dashboard"),
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
                          Get.toNamed("/all_categories");
                        },
                        style: TextButton.styleFrom(
                            textStyle: GoogleFonts.poppins()),
                        child: const Text("View all"),
                      )
                    ],
                  ),
                  Container(
                    height: 420,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        mainAxisExtent: 200,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, i) {
                        return categoryContainer();
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
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            textStyle: GoogleFonts.poppins()),
                        child: const Text("View all"),
                      )
                    ],
                  ),
                  Container(
                    height: 500,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        mainAxisExtent: 240,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                            onTap: () {},
                            child: workerContainer(
                                name: "John Smith",
                                rate: 110,
                                experience: "7 Years Exp.",
                                ratings: "⭐⭐⭐⭐",
                                imageURL:
                                    "https://source.unsplash.com/random/?$i background,dark"));
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PersistentTabController persistentTabController;
  // isAdmin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Global.isAdmin = prefs.getBool('isAdmin')!;
  // }

  @override
  void initState() {
    super.initState();
    // isAdmin();
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
      bottomNavBarItem(icon: const Icon(Icons.history), title: "History"),
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
