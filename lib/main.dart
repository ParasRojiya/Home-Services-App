import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:home_services_app/views/screens/edit_category.dart';
import 'package:home_services_app/views/screens/add_worker.dart';
import 'package:home_services_app/views/screens/all_categories_page.dart';
import 'package:home_services_app/views/screens/all_workers_page.dart';
import 'package:home_services_app/views/screens/services_page.dart';
import 'package:home_services_app/views/screens/user/worker_details_page.dart';
import 'package:home_services_app/views/screens/users_list.dart';
import 'global/global.dart';
import 'package:home_services_app/views/screens/account_page.dart';
import 'package:home_services_app/views/screens/history_page.dart';
import 'package:home_services_app/views/screens/home_page.dart';
import 'package:home_services_app/views/screens/login_page.dart';
import 'package:home_services_app/views/screens/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  Global.isAdmin = prefs.getBool('isAdmin') ?? false;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: (isLoggedIn) ? "/" : "/login_page",
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/login_page', page: () => const LoginPage()),
        GetPage(name: '/sign_up_page', page: () => const SignUpPage()),
        GetPage(name: '/history_page', page: () => const HistoryPage()),
        GetPage(name: '/account_page', page: () => const AccountPage()),
        GetPage(name: '/all_categories', page: () => const AllCategories()),
        GetPage(name: '/all_workers', page: () => const AllWorkers()),
        GetPage(name: '/edit_category', page: () => const EditCategory()),
        GetPage(name: '/edit_worker', page: () => const EditWorker()),
        GetPage(name: '/worker_details', page: () => const WorkerDetailsPage()),
        GetPage(name: '/users_list', page: () => const UsersList()),
        GetPage(
            name: '/service_details_page',
            page: () => const ServiceDetailsPage()),
      ],
    ),
  );
}
