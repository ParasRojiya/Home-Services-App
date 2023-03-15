import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../global/global.dart';
import '../../global/text_field_decoration.dart';
import '../../helper/cloud_firestore_helper.dart';
import '../../helper/firebase_auth_helper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> changePassWordFormKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newConfirmPasswordController =
      TextEditingController();

  String date = '';
  File? showImage;
  String? image;
  Uint8List? imgData;
  Map<String, dynamic>? userData;

  String? currentPassword;
  String? newPassword;
  String? newConfirmPassword;

  @override
  void initState() {
    dateInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.password),
          )
        ],
        title: Text(
          "Change Profile",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: fromKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    (showImage != null)
                        ? CircleAvatar(
                            maxRadius: 60,
                            backgroundColor: Colors.blueGrey,
                            backgroundImage: FileImage(showImage!),
                          )
                        : const CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Clipart.png",
                            ),
                          ),
                    Positioned(
                      top: 130,
                      child: FloatingActionButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();

                          XFile? xFile = await picker.pickImage(
                              source: ImageSource.camera);
                          imgData = await xFile?.readAsBytes();
                          imgData = await FlutterImageCompress.compressWithList(
                            imgData!,
                            minHeight: 200,
                            minWidth: 200,
                            quality: 80,
                          );
                          setState(() {
                            showImage = File(xFile!.path);
                          });
                        },
                        mini: true,
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${Global.currentUser!['email']}",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                    Icon(
                      Icons.email,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  changePassword();
                },
                child: Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Change Password",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                      Icon(
                        Icons.lock,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter First Name...' : null;
                  },
                  controller: fullNameController,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white24,
                        ),
                      ),
                      hintText: "Full Name",
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Colors.grey.shade600,
                      ),
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: nickNameController,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Nickname ...' : null;
                  },
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Nick Name",
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Colors.grey.shade600,
                      ),
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  height: 50,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (date=='')?'Date of Birth':date,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            String formattedDate = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';

                            setState(() {
                              date = formattedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Phone Number' : null;
                  },
                  controller: phoneController,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Phone Number",
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Colors.grey.shade600,
                      ),
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: TextFormField(
                  validator: (val) {
                    return (val!.isEmpty) ? 'Enter Address' : null;
                  },
                  controller: addressController,
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      hintText: "Address",
                      suffixIcon: Icon(
                        Icons.edit,
                        color: Colors.grey.shade600,
                      ),
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  if (fromKey.currentState!.validate()) {
                    image = base64.encode(imgData!);

                    setState(() {
                      userData = {
                        'image': image,
                        'fullName': fullNameController.text,
                        'nickname': nickNameController.text,
                        'dob': dateInput.text,
                        'mobile': phoneController.text,
                        'email': emailController.text,
                        'address': addressController.text,
                      };
                    });

                    // DocumentReference docRef = await FireStoreHelper
                    //     .fireStoreHelper
                    //     .insertUserData(data: userData as Map<String, dynamic>);

                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.deepPurpleAccent,
                                      size: 120,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "Created Successfully",
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          userData = {
                                            'image': showImage,
                                            'fullName': fullNameController.text,
                                            'nickname': nickNameController.text,
                                            'dob': dateInput.text,
                                            'mobile': phoneController.text,
                                            'email': emailController.text,
                                            'address': addressController.text,
                                          };
                                        });
                                        Navigator.of(context)
                                            .pushReplacementNamed('/',
                                                arguments: userData);
                                        setState(() {
                                          showImage = null;
                                        });
                                        fullNameController.clear();
                                        nickNameController.clear();
                                        dateInput.clear();
                                        phoneController.clear();
                                        emailController.clear();
                                        addressController.clear();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "OK",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        height: 45,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurpleAccent,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.balooBhai2(
                        fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
