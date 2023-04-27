import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

import '../../global/global.dart';
import '../../helper/firebase_auth_helper.dart';
import '../../helper/local_notification_helper.dart';
import '../../utils/account_option_container.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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

  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController profileEmailController = TextEditingController();
  final TextEditingController profileNameController = TextEditingController();

  String? profileName;
  String? profileEmail;

  bool isDark = false;

  @override
  void initState() {
    currentUserData();

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
              _launchUrl(url: 'https://flutter.dev');
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
              icon: CupertinoIcons.person,
            ),
            accountOptionContainer(
              title: "Wallet",
              onTap: () {
                if (Global.currentUser!['wallet'] != null) {
                  Get.toNamed("/add_card",
                      arguments: Global.currentUser!['wallet']);
                } else {
                  Get.toNamed("/add_card");
                }
              },
              icon: CupertinoIcons.creditcard,
            ),
            accountOptionContainer(
              title: "FAQs",
              onTap: () {
                Get.toNamed('/faqs');
              },
              icon: CupertinoIcons.flag,
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
                // Get.toNamed('/privacy_policy_page');
                _launchUrl(
                    url: "https://ourpocily.blogspot.com/2023/03/policy.html");
              },
              icon: CupertinoIcons.shield_lefthalf_fill,
            ),
            accountOptionContainer(
              title: "Terms & Condition",
              onTap: () {
                //Get.toNamed('/terms_condition_page');
                _launchUrl(
                    url:
                        "https://flutterninjas.blogspot.com/2022/12/terms-and-conditions.html");
              },
              icon: CupertinoIcons.doc_on_clipboard,
            ),
            (Global.isAdmin)
                ? Container()
                : accountOptionContainer(
                    title: "Rating & Review",
                    onTap: () {
                      dynamic rating = Global.currentUser!['rate'];
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => RatingDialog(
                          initialRating: rating.toDouble(),
                          title: const Text(
                            'Share Your Experience',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          message: const Text(
                            'Tap a star to set your rating',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          image: Container(
                            alignment: Alignment.bottomCenter,
                            height: 200,
                            width: 80,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/logo/1.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: const Text(
                              'Home Services',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          submitButtonText: 'Submit',
                          commentHint: 'Write a review(Optional)',
                          onCancelled: () => print('cancelled'),
                          onSubmitted: (response) async {
                            if (response.rating >= 1) {
                              Fluttertoast.showToast(
                                  msg: "Thank You For Your Feedback",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                            }
                            Map<String, dynamic> data = {
                              'rate': response.rating,
                              'comment': response.comment,
                            };
                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateUsersRecords(
                                    id: Global.currentUser!['email'],
                                    data: data);
                          },
                        ),
                      );
                    },
                    icon: Icons.star,
                  ),
            (Global.isAdmin == true)
                ? accountOptionContainer(
                    title: "View Rating & Reviews",
                    onTap: () {
                      Get.toNamed('/rating_page');
                    },
                    icon: Icons.sentiment_neutral_rounded,
                  )
                : Container(),
            (Global.isAdmin)
                ? accountOptionContainer(
                    title: "View Users",
                    onTap: () {
                      Get.toNamed('/users_list');
                    },
                    icon: Icons.list)
                : Container(),
            accountOptionContainer(
              title: "Help",
              onTap: () {
                contact();
              },
              icon: CupertinoIcons.question_circle,
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
                                  prefs.remove('isWorker');

                                  await FireBaseAuthHelper.fireBaseAuthHelper
                                      .signOut();
                                  Get.offNamedUntil(
                                      '/login_page', (route) => false);
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

  Future<void> _launchUrl({required String url}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  // editProfile() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         profileNameController.text = Global.currentUser!['name'];
  //         profileEmailController.text = Global.currentUser!['email'];
  //         return AlertDialog(
  //           title: Text(
  //             "Edit Your Profile",
  //             style: GoogleFonts.poppins(),
  //           ),
  //           content: Form(
  //             key: editProfileFormKey,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextFormField(
  //                   controller: profileNameController,
  //                   decoration: textFieldDecoration(
  //                       icon: Icons.person, name: "User Name"),
  //                   onSaved: (val) {
  //                     profileName = val;
  //                   },
  //                   validator: (val) =>
  //                       (val!.isEmpty) ? "Please add user name" : null,
  //                 ),
  //                 const SizedBox(height: 10),
  //                 TextFormField(
  //                   controller: profileEmailController,
  //                   decoration: textFieldDecoration(
  //                       icon: Icons.mail, name: "User Email"),
  //                   onSaved: (val) {
  //                     profileEmail = val;
  //                   },
  //                   validator: (val) =>
  //                       (val!.isEmpty) ? "Please add user email" : null,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             OutlinedButton(
  //               onPressed: () {
  //                 Get.back();
  //               },
  //               child: Text(
  //                 "Cancel",
  //                 style: GoogleFonts.poppins(),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 if (editProfileFormKey.currentState!.validate()) {
  //                   editProfileFormKey.currentState!.save();
  //
  //                   Map<String, dynamic> data = {
  //                     'name': profileName,
  //                     'email': profileEmail,
  //                   };
  //
  //                   await CloudFirestoreHelper.cloudFirestoreHelper
  //                       .updateUsersRecords(
  //                           id: Global.currentUser!['email'], data: data);
  //                   await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
  //
  //                   Get.offNamedUntil("/login_page", (route) => false);
  //                 }
  //               },
  //               child: Text(
  //                 "Edit Profile",
  //                 style: GoogleFonts.poppins(),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

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
