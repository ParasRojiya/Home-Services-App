import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/global/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/button_syle.dart';
import '../../global/global.dart';
import '../../global/text_field_decoration.dart';
import '../../helper/cloud_firestore_helper.dart';
import '../../helper/firebase_auth_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? email;
  String? password;
  bool isNotVisible = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.clear();
    emailController.clear();

    email = null;
    password = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                height: 260,
                width: 190,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo/1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Email First..." : null;
                },
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) {
                  email = val;
                },
                decoration: textFieldDecoration(
                  icon: Icons.email,
                  name: "Email",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Password First..." : null;
                },
                onSaved: (val) {
                  password = val;
                },
                obscureText: isNotVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(Icons.password),
                  label: Text("Password",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      )),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        (isNotVisible == false)
                            ? isNotVisible = true
                            : isNotVisible = false;
                      });
                    },
                    child: Icon((isNotVisible == false)
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  ConnectivityResult connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      prefs.setString('currentUser', email!);

                      await CloudFirestoreHelper.firebaseFirestore
                          .collection('users')
                          .doc(email)
                          .snapshots()
                          .forEach((element) async {
                        Global.currentUser = {
                          'name': element.data()?['name'],
                          'email': element.data()?['email'],
                          'password': element.data()?['password'],
                          'role': element.data()?['role'],
                          'bookings': element.data()?['bookings'],
                        };

                        if (element.data()?['role'] == 'admin') {
                          await prefs.setBool('isAdmin', true);
                          await prefs.setBool('isLoggedIn', true);
                          Global.isAdmin = prefs.getBool('isAdmin') ?? true;

                          Global.user = await FireBaseAuthHelper
                              .fireBaseAuthHelper
                              .signIn(email: email!, password: password!);
                          snackBar(
                              user: Global.user,
                              context: context,
                              name: "Sign In");
                        } else {
                          await prefs.setBool('isAdmin', false);
                          await prefs.setBool('isLoggedIn', true);
                          Global.isAdmin = prefs.getBool('isAdmin') ?? false;

                          Global.user = await FireBaseAuthHelper
                              .fireBaseAuthHelper
                              .signIn(email: email!, password: password!);
                          Navigator.of(context).pushReplacementNamed(
                              "/user_home_page",
                              arguments: Global.user);
                        }
                      });
                      Global.cart = Global.currentUser!['cart'];
                    }
                  } else {
                    connectionSnackBar(context: context);
                  }
                },
                style: elevatedButtonStyle(),
                child: const Text("Sign in"),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ? ",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed("/sign_up_page");
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 2),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  ConnectivityResult connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    Global.user = await FireBaseAuthHelper.fireBaseAuthHelper
                        .signInWithGoogle();

                    if (Global.user != null) {
                      Global.currentUser = {
                        "name": Global.user!.displayName,
                        "email": Global.user!.email,
                        "role": "user",
                        "password": "password"
                      };

                      Map<String, dynamic> data = {
                        "name": Global.user!.displayName,
                        "email": Global.user!.email,
                        "role": "user",
                        "password": "password",
                        "isActive": true,
                      };
                      await CloudFirestoreHelper.cloudFirestoreHelper
                          .insertDataInUsersCollection(data: data);
                    }
                    await snackBar(
                        user: Global.user, context: context, name: "Login");
                  } else {
                    connectionSnackBar(context: context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Global.color, width: 1.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://play-lh.googleusercontent.com/6UgEjh8Xuts4nwdWzTnWH8QtLuHqRMUB7dp24JYVE2xcYzq4HA8hFfcAbU-R-PC_9uA1"),
                        radius: 25,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        "Continue with Google",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
