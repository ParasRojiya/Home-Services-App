import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import '../../global/global.dart';
import '../../helper/firebase_auth_helper.dart';
import '../../utils/account_option_container.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global/text_field_decoration.dart';

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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png"),
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
              title: "Change Password",
              onTap: () {
                changePassword();
              },
              icon: Icons.lock,
            ),
            accountOptionContainer(
              title: "Contact US",
              onTap: null,
              icon: Icons.contact_mail_sharp,
            ),
            accountOptionContainer(
              title: "FAQs",
              onTap: null,
              icon: Icons.flag,
            ),
            accountOptionContainer(
              title: "Help",
              onTap: null,
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
}
