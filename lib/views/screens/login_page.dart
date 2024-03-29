import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/global/snack_bar.dart';
import 'package:home_services_app/helper/fcm_helper.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
              const SizedBox(height: 98),
              Container(
                height: 260,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo/1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Text(
              //   "Login to your account",
              //   style: GoogleFonts.poppins(
              //     fontSize: 32,
              //     fontWeight: FontWeight.w600,
              //   ),
              //   // textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 18),
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
                  fillColor: Global.color.withOpacity(0.03),
                  filled: true,
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintStyle: GoogleFonts.habibi(
                    fontWeight: FontWeight.w300,
                  ),
                  hintText: "Enter your password here",
                  prefixIcon: const Icon(Icons.password),
                  label: Text("Password",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
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
                          'imageURL': element.data()?['imageURL'],
                          'DOB': element.data()?['DOB'],
                          'token': element.data()?['token'],
                          'wallet': element.data()?['wallet'],
                          'rate': element.data()?['rate'],
                          'comment': element.data()?['comment'],
                          'cart': element.data()?['cart'],
                          'recentlyViewed': element.data()?['recentlyViewed'],
                        };

                        if (element.data()?['role'] == 'admin') {
                          await prefs.setBool('isAdmin', true);
                          await prefs.setBool('isWorker', false);
                          await prefs.setBool('isLoggedIn', true);
                          await prefs.setString('currentUser', email!);
                          Global.isAdmin = prefs.getBool('isAdmin') ?? true;
                          Global.isWorker = prefs.getBool('isWorker') ?? false;

                          Global.user = await FireBaseAuthHelper
                              .fireBaseAuthHelper
                              .signIn(email: email!, password: password!);

                          if (Global.user != null) {
                            snackBar(
                                user: Global.user,
                                context: context,
                                name: "Sign In");

                            Map<String, dynamic> data = {
                              'token': await FCMHelper.fcmHelper.getToken(),
                            };

                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateUsersRecords(id: email!, data: data);

                            Get.offNamedUntil(
                                '/admin_home_page', (route) => false);
                          } else {
                            errorSnackBar(
                                msg: "Sign in failed...", context: context);
                          }
                        }

                        if (element.data()?['role'] == 'user') {
                          await prefs.setBool('isAdmin', false);
                          await prefs.setBool('isWorker', false);
                          await prefs.setBool('isLoggedIn', true);
                          await prefs.setString('currentUser', email!);
                          Global.isAdmin = prefs.getBool('isAdmin') ?? false;
                          Global.isWorker = prefs.getBool('isWorker') ?? false;

                          Global.user = await FireBaseAuthHelper
                              .fireBaseAuthHelper
                              .signIn(email: email!, password: password!);

                          if (Global.user != null) {
                            snackBar(
                                user: Global.user,
                                context: context,
                                name: "Sign In");

                            Map<String, dynamic> data = {
                              'token': await FCMHelper.fcmHelper.getToken(),
                            };

                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateUsersRecords(id: email!, data: data);

                            Get.offNamedUntil(
                                "/user_home_page", (route) => false);
                          } else {
                            errorSnackBar(
                                msg: "Sign in failed...", context: context);
                          }
                        }

                        if (element.data()?['role'] == 'worker') {
                          await prefs.setBool('isAdmin', false);
                          await prefs.setBool('isWorker', true);
                          await prefs.setBool('isLoggedIn', true);
                          await prefs.setString('currentUser', email!);
                          Global.isAdmin = prefs.getBool('isAdmin') ?? false;
                          Global.isWorker = prefs.getBool('isWorker') ?? true;

                          Global.user = await FireBaseAuthHelper
                              .fireBaseAuthHelper
                              .signIn(email: email!, password: password!);

                          if (Global.user != null) {
                            snackBar(
                                user: Global.user,
                                context: context,
                                name: "Sign In");

                            Map<String, dynamic> data = {
                              'token': await FCMHelper.fcmHelper.getToken(),
                            };

                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateUsersRecords(id: email!, data: data);

                            Get.offNamedUntil(
                                "/worker_home_page", (route) => false);
                          } else {
                            errorSnackBar(
                                msg: "Sign in failed...", context: context);
                          }
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

              const SizedBox(height: 15),
              // GestureDetector(
              //   onTap: () async {
              //     ConnectivityResult connectivityResult =
              //         await (Connectivity().checkConnectivity());
              //
              //     if (connectivityResult == ConnectivityResult.mobile ||
              //         connectivityResult == ConnectivityResult.wifi) {
              //       Global.user = await FireBaseAuthHelper.fireBaseAuthHelper
              //           .signInWithGoogle();
              //
              //       if (Global.user != null) {
              //         Global.currentUser = {
              //           "name": Global.user!.displayName,
              //           "email": Global.user!.email,
              //           "role": "user",
              //           "password": "password"
              //         };
              //
              //         Map<String, dynamic> data = {
              //           "name": Global.user!.displayName,
              //           "email": Global.user!.email,
              //           "role": "user",
              //           "password": "password",
              //           "isActive": true,
              //         };
              //         await CloudFirestoreHelper.cloudFirestoreHelper
              //             .insertDataInUsersCollection(data: data);
              //       }
              //       await snackBar(
              //           user: Global.user, context: context, name: "Login");
              //     } else {
              //       connectionSnackBar(context: context);
              //     }
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Global.color, width: 1.2),
              //       borderRadius: BorderRadius.circular(100),
              //     ),
              //     padding: const EdgeInsets.symmetric(vertical: 7),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const CircleAvatar(
              //           backgroundImage: NetworkImage(
              //               "https://play-lh.googleusercontent.com/6UgEjh8Xuts4nwdWzTnWH8QtLuHqRMUB7dp24JYVE2xcYzq4HA8hFfcAbU-R-PC_9uA1"),
              //           radius: 25,
              //         ),
              //         const SizedBox(width: 7),
              //         Text(
              //           "Continue with Google",
              //           style: GoogleFonts.poppins(
              //             fontWeight: FontWeight.w600,
              //             color: Colors.grey.shade700,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
