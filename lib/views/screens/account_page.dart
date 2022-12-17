import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/firebase_auth_helper.dart';
import '../../utils/account_option_container.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Account"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            CircleAvatar(
              radius: 90,
            ),
            SizedBox(height: 10),
            accountOptionContainer(
              title: "Change Password",
              onTap: null,
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
}
