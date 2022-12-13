import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
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

  bool? isSignedIn = prefs.getBool('isSignedIn') ?? false;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: "/login_page",
      initialRoute: (isSignedIn == true) ? '/' : '/login_page',
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/login_page', page: () => const LoginPage()),
        GetPage(name: '/sign_up_page', page: () => const SignUpPage()),
        GetPage(name: '/history_page', page: () => const HistoryPage()),
        GetPage(name: '/account_page', page: () => const AccountPage()),
        GetPage(name: '/all_categories', page: () => const AccountPage()),
      ],
    ),
  );
}
