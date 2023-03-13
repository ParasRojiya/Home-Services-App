import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/global.dart';
import '../../global/text_field_decoration.dart';
import '../../helper/firebase_auth_helper.dart';
import '../../utils/account_option_container.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GlobalKey<FormState> changePassWordFormKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newConfirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController profileEmailController = TextEditingController();
  final TextEditingController profileNameController = TextEditingController();

  String? profileName;
  String? profileEmail;

  String? currentPassword;
  String? newPassword;
  String? newConfirmPassword;

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
            const CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png",
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
                editProfile();
              },
              icon: Icons.person,
            ),
            accountOptionContainer(
              title: "Change Password",
              onTap: () {
                changePassword();
              },
              icon: Icons.lock,
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

  changePassword() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Change Your Password"),
            content: Form(
              key: changePassWordFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentPasswordController,
                    onSaved: (val) {
                      currentPassword = val;
                    },
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter your current password"
                        : (val != Global.currentUser!['password'])
                            ? "Wrong Current password"
                            : null,
                    decoration: textFieldDecoration(
                        icon: Icons.lock, name: "Current Password"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newPasswordController,
                    onSaved: (val) {
                      newPassword = val;
                    },
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter your new password"
                        : null,
                    decoration: textFieldDecoration(
                        icon: Icons.lock, name: "New Password"),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newConfirmPasswordController,
                    onSaved: (val) {
                      newConfirmPassword = val;
                    },
                    validator: (val) => (val != newPasswordController.text)
                        ? "confirm password does not match new password"
                        : (val!.isEmpty)
                            ? "Please confirm your new password"
                            : null,
                    decoration: textFieldDecoration(
                        icon: Icons.lock, name: "Confirm New Password"),
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
                  )),
              ElevatedButton(
                  onPressed: () async {
                    if (changePassWordFormKey.currentState!.validate()) {
                      changePassWordFormKey.currentState!.save();
                      await FireBaseAuthHelper.fireBaseAuthHelper
                          .changePassword(
                              newPassword: newPassword!, context: context);
                      Map<String, dynamic> data = {
                        'name': Global.currentUser!['name'],
                        'email': Global.currentUser!['email'],
                        'password': newPassword,
                        'role': Global.currentUser!['role'],
                      };
                      await CloudFirestoreHelper.cloudFirestoreHelper
                          .updateUsersRecords(
                              id: Global.currentUser!['email'], data: data);
                      await FireBaseAuthHelper.fireBaseAuthHelper.signOut();
                      Get.offAndToNamed('/login_page');
                    }
                  },
                  child: Text(
                    "Set New Password",
                    style: GoogleFonts.poppins(),
                  )),
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
                    int number = 7874764505;
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
