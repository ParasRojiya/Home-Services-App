import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/fcm_helper.dart';
import 'package:home_services_app/helper/firebase_auth_helper.dart';

import '../../global/button_syle.dart';
import '../../global/global.dart';
import '../../global/snack_bar.dart';
import '../../global/text_field_decoration.dart';
import '../../helper/cloud_firestore_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String? email;
  String? password;
  String? password2;
  String? name;

  @override
  void dispose() {
    super.dispose();
    passwordController.clear();
    password2Controller.clear();
    emailController.clear();
    nameController.clear();

    email = null;
    password = null;
    password2 = null;
    name = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Create an Account",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    color: Global.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
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
                controller: nameController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Name First..." : null;
                },
                onSaved: (val) {
                  name = val;
                },
                decoration: textFieldDecoration(
                  icon: Icons.person,
                  name: "Name",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Email First..." : null;
                },
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
                obscureText: true,
                decoration: textFieldDecoration(
                  icon: Icons.password,
                  name: "Password",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: password2Controller,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Password First..." : null;
                },
                onSaved: (val) {
                  password2 = val;
                },
                obscureText: true,
                decoration: textFieldDecoration(
                  icon: Icons.password,
                  name: "Confirm Password",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  ConnectivityResult connectivityResult =
                      await (Connectivity().checkConnectivity());

                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      if (password == password2) {
                        User? user = await FireBaseAuthHelper.fireBaseAuthHelper
                            .signUp(email: email!, password: password!);
                        if (user != null) {
                          await CloudFirestoreHelper.cloudFirestoreHelper
                              .insertDataInUsersCollection(
                            data: {
                              "name": name,
                              "email": email,
                              "role": "user",
                              "password": password,
                              "isActive": true,
                              "imageURL":
                                  "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png",
                              "bookings": [],
                              "cart": [],
                              "DOB": null,
                              "contact": null,
                              "address": null,
                              "token": await FCMHelper.fcmHelper.getToken(),
                              "comment": "",
                              "rate": 0.toDouble(),
                            },
                          );

                          await CloudFirestoreHelper.cloudFirestoreHelper
                              .insertChatRecords(
                                  id: email!, data: {"chats": []});
                        }

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Successfully registered",
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ));

                        Get.offNamedUntil('/login_page', (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            content: Row(
                              children: [
                                const Icon(Icons.password, color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  "Password Don't Match..",
                                  style: GoogleFonts.poppins(),
                                ),
                              ],
                            ),
                          ),
                        );
                        passwordController.clear();
                        password2Controller.clear();
                        password = null;
                        password2 = null;
                        formKey.currentState!.validate();
                      }
                    }
                  } else {
                    connectionSnackBar(context: context);
                  }
                },
                style: elevatedButtonStyle(),
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ? ",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
