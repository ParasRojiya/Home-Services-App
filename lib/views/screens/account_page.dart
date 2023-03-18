import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

import '../../global/global.dart';
import '../../global/text_field_decoration.dart';
import '../../helper/firebase_auth_helper.dart';
import '../../helper/local_notification_helper.dart';
import '../../utils/account_option_container.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController profileEmailController = TextEditingController();
  final TextEditingController profileNameController = TextEditingController();

  String? profileName;
  String? profileEmail;
  bool isDark = false;

  @override
  void initState() {
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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print(response.payload);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _launchUrl();
            },
            icon: const Icon(
              CupertinoIcons.info,
              size: 22,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                Global.currentUser!['imageURL'],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${Global.currentUser!['name']}",
              style: GoogleFonts.poppins(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            accountOptionContainer(
              title: "Edit Profile",
              onTap: () {
                Get.toNamed("/edit_profile");
              },
              icon:  CupertinoIcons.person,
            ),
            accountOptionContainer(
              title: "Wallet",
              onTap: () {
                Get.toNamed("/add_card");
              },
              icon: CupertinoIcons.creditcard,
            ),
            accountOptionContainer(
              title: "FAQs",
              onTap: (){
                Get.toNamed('/faqs');
              },
              icon:  CupertinoIcons.flag,

            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.eye,
                      color: Colors.black87, size: 22),
                  const SizedBox(width: 15),
                  Text(
                    'Dark Theme',
                    style: GoogleFonts.poppins(),
                  ),
                  const Spacer(),
                  Switch(value: isDark, onChanged: (_) {})
                ],
              ),
            ),
            accountOptionContainer(
              title: "Privacy And Policy",
              onTap: () {
                Get.toNamed('/privacy_policy_page');
              },
              icon:CupertinoIcons.shield_lefthalf_fill,
            ),
            accountOptionContainer(
              title: "Terms & Condition",
              onTap: () {
                Get.toNamed('/terms_condition_page');
              },
              icon: CupertinoIcons.doc_on_clipboard,
            ),
            accountOptionContainer(
              title: "Help",
              onTap: () {
                contact();
              },
              icon:  CupertinoIcons.question_circle,
            ),
            accountOptionContainer(
              title: "Log Out",
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  builder: (context) {
                    return Container(
                      height: 180,
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
                            'Logout',
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
                            'Are you sure you want to logout?',
                            style: GoogleFonts.balooBhai2(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
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
                                onTap: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  await prefs.setBool('isLoggedIn', false);
                                  prefs.remove('isAdmin');

                                  await FireBaseAuthHelper.fireBaseAuthHelper
                                      .signOut();
                                  Get.offAndToNamed("/login_page");
                                },
                                child: Container(
                                  height: 55,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.indigo.shade400,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Logout',
                                    style: GoogleFonts.habibi(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );





              },
              icon: CupertinoIcons.power,
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
}

  editProfile() {
    showDialog(
        context: context,
        builder: (context) {
          profileNameController.text = Global.currentUser!['name'];
          profileEmailController.text = Global.currentUser!['email'];
          return AlertDialog(
            title: Text(
              "Edit Your Profile",
              style: GoogleFonts.poppins(),
            ),
            content: Form(
              key: editProfileFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: profileNameController,
                    decoration: textFieldDecoration(
                        icon: Icons.person, name: "User Name"),
                    onSaved: (val) {
                      profileName = val;
                    },
                    validator: (val) =>
                        (val!.isEmpty) ? "Please add user name" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: profileEmailController,
                    decoration: textFieldDecoration(
                        icon: Icons.mail, name: "User Email"),
                    onSaved: (val) {
                      profileEmail = val;
                    },
                    validator: (val) =>
                        (val!.isEmpty) ? "Please add user email" : null,
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (editProfileFormKey.currentState!.validate()) {
                    editProfileFormKey.currentState!.save();

                    Map<String, dynamic> data = {
                      'name': profileName,
                      'email': profileEmail,
                    };

                    await CloudFirestoreHelper.cloudFirestoreHelper
                        .updateUsersRecords(
                            id: Global.currentUser!['email'], data: data);
                    await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
                    Get.offAndToNamed('/login_page');
                  }
                },
                child: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          );
        });
  }

  contact() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contact Us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              accountOptionContainer(
                  title: "Call us",
                  onTap: () async {
                    Uri url = Uri.parse("tel:+917874764505");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("can't be luanched..."),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }

                  },
                  icon: Icons.call),
              accountOptionContainer(
                  title: "Mail us",
                  onTap: () async {
                    Uri url = Uri.parse(
                        "mailto:roronoazoro5466@gmail.com?subject=Demo&body=Hello");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Can't be launched..."),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: Icons.mail),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
