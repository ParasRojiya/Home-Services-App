import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_app/views/screens/account_page.dart';
import 'package:home_services_app/views/screens/admin/add_new_service.dart';
import 'package:home_services_app/views/screens/admin/add_worker.dart';
import 'package:home_services_app/views/screens/admin/admin_home_page.dart';
import 'package:home_services_app/views/screens/admin/all_categories_page.dart';
import 'package:home_services_app/views/screens/admin/all_services_page.dart';
import 'package:home_services_app/views/screens/admin/all_workers_page.dart';
import 'package:home_services_app/views/screens/admin/chats_page.dart';
import 'package:home_services_app/views/screens/admin/edit_service_page.dart';
import 'package:home_services_app/views/screens/admin/users_list.dart';
import 'package:home_services_app/views/screens/chat_page.dart';
import 'package:home_services_app/views/screens/document/FAQs.dart';
import 'package:home_services_app/views/screens/document/privacy_policy.dart';
import 'package:home_services_app/views/screens/document/terms_condition_page.dart';
import 'package:home_services_app/views/screens/edit_profile.dart';
import 'package:home_services_app/views/screens/login_page.dart';
import 'package:home_services_app/views/screens/sign_up_page.dart';
import 'package:home_services_app/views/screens/user/add_card.dart';
import 'package:home_services_app/views/screens/user/book_category.dart';
import 'package:home_services_app/views/screens/user/book_service_page.dart';
import 'package:home_services_app/views/screens/user/history_page.dart';
import 'package:home_services_app/views/screens/user/service_receipt_page.dart';
import 'package:home_services_app/views/screens/user/worker_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global/global.dart';
import 'views/screens/user/user_home_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  Global.isAdmin = prefs.getBool('isAdmin') ?? false;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    GetMaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: (isLoggedIn)
          ? (Global.isAdmin)
              ? "/admin_home_page"
              : "/user_home_page"
          : "/login_page",
      getPages: [
        GetPage(name: '/login_page', page: () => const LoginPage()),
        GetPage(name: '/sign_up_page', page: () => const SignUpPage()),
        GetPage(name: '/account_page', page: () => const AccountPage()),
        GetPage(name: '/edit_profile', page: () => const EditProfile()),
        GetPage(name: '/chat_page', page: () => const ChatPage()),
        GetPage(name: '/privacy_policy_page', page: () => const PrivacyPage()),
        GetPage(
            name: '/terms_condition_page',
            page: () => const TermsAndConditionPage()),
        GetPage(name: '/faqs', page: () => const FAQs()),

        //ADMIN SCREENS
        GetPage(name: '/admin_home_page', page: () => const AdminHomeScreen()),
        GetPage(
            name: '/all_categories_page', page: () => const AllCategories()),
        GetPage(
            name: '/all_services_page', page: () => const AllServicesPage()),
        GetPage(name: '/edit_service_page', page: () => const EditService()),
        GetPage(name: '/add_service_page', page: () => const AddNewService()),
        GetPage(name: '/all_workers', page: () => const AllWorkers()),
        GetPage(name: '/add_worker', page: () => const AddWorker()),
        GetPage(name: '/users_list', page: () => const UsersList()),
        GetPage(name: '/chats_page', page: () => const ChatsPage()),

        //USER SCREENS
        GetPage(name: '/user_home_page', page: () => const UserHomeScreen()),
        GetPage(name: '/history_page', page: () => const HistoryPage()),
        GetPage(name: '/worker_details', page: () => const WorkerDetailsPage()),
        GetPage(name: '/book_category', page: () => const BookCategory()),
        GetPage(name: '/book_service', page: () => const BookService()),
        GetPage(name: '/add_card', page: () => const AddCardPage()),
        GetPage(
            name: '/service_receipt', page: () => const ServiceReceiptPage()),
      ],
    ),
  );
}
