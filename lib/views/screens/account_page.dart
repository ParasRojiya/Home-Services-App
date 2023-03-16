import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
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
              icon: Icons.person,
            ),
            accountOptionContainer(
              title: "FAQs",
              onTap: null,
              icon: Icons.flag,
            ),
            accountOptionContainer(
              title: "About us",
              onTap: () {
                launchURL();
              },
              icon: Icons.info,
            ),
            accountOptionContainer(
              title: "Help",
              onTap: () {
                contact();
              },
              icon: Icons.help,
            ),
            accountOptionContainer(
              title: "Log Out",
              onTap: () async {
                await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
                Get.offAndToNamed("/login_page");
              },
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  launchURL() async {
    const url = 'https://flutter.io';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar("Could not launch $url", "Can't Open");
      throw 'Could not launch $url';
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
