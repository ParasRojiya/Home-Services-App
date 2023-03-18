import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/global/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/service_category_controller.dart';
import '../../global/button_syle.dart';
import '../../global/global.dart';
import '../../global/text_field_decoration.dart';
import '../../helper/cloud_firestore_helper.dart';
import '../../helper/cloud_storage_helper.dart';
import '../../helper/firebase_auth_helper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> changePassWordFormKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newConfirmPasswordController =
      TextEditingController();

  String? date;

  String? fullName;
  String? contactNo;
  String? address;

  String? currentPassword;
  String? newPassword;
  String? newConfirmPassword;

  final ServiceCategoryController serviceCategoryController =
      Get.put(ServiceCategoryController());

  @override
  void initState() {
    super.initState();

    fullNameController.text = Global.currentUser!['name'];
    if (Global.currentUser!['contact'] != null &&
        Global.currentUser!['address'] != null &&
        Global.currentUser!['DOB'] != null) {
      phoneController.text = Global.currentUser!['contact'];
      addressController.text = Global.currentUser!['address'];
      date = Global.currentUser!['DOB'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Change Profile",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                GetBuilder(
                  builder: (ServiceCategoryController controller) =>
                      CircleAvatar(
                    radius: 90,
                    backgroundImage: (controller.image != null)
                        ? FileImage(controller.image!) as ImageProvider
                        : NetworkImage(
                            Global.currentUser!['imageURL'],
                          ),
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              alignment: Alignment.center,
                              title: const Text("Select Image Source"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      serviceCategoryController
                                          .addImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Gallery")),
                                ElevatedButton(
                                    onPressed: () async {
                                      serviceCategoryController
                                          .addImage(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Camera")),
                              ],
                            );
                          });
                    },
                    child: const Text("Add Image")),
                const SizedBox(height: 30),
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
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                      Icon(
                        Icons.email,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (val) {
                      return (val!.isEmpty) ? 'Enter First Name...' : null;
                    },
                    controller: fullNameController,
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    decoration: textFieldDecoration(
                        name: "Full Name", icon: Icons.edit),
                    onSaved: (val) {
                      fullName = val;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      return (val!.isEmpty) ? 'Enter Phone Number' : null;
                    },
                    controller: phoneController,
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    decoration: textFieldDecoration(
                        icon: Icons.phone, name: "Contact No."),
                    onSaved: (val) {
                      contactNo = val;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.03),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            String formattedDate =
                                '${pickedDate.day} - ${pickedDate.month} - ${pickedDate.year}';

                            setState(() {
                              date = formattedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                      Text(
                        (Global.currentUser!['DOB'] == null)
                            ? (date == null)
                                ? 'Date of Birth'
                                : date
                            : Global.currentUser!['DOB'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: TextFormField(
                      validator: (val) {
                        return (val!.isEmpty) ? 'Enter Address' : null;
                      },
                      controller: addressController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(color: Colors.black, fontSize: 17),
                      decoration: textFieldDecoration(
                          icon: Icons.home, name: "Address"),
                      onSaved: (val) {
                        address = val;
                      }),
                ),
                const SizedBox(height: 30),
                Container(
                  width: Get.width * 0.90,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    style: elevatedButtonStyle(),
                    child: const Text("Edit Profile"),
                  ),
                ),
              ],
            ),
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

  updateProfile() async {
    if (fromKey.currentState!.validate()) {
      fromKey.currentState!.save();

      if (serviceCategoryController.image != null) {
        await CloudStorageHelper.cloudStorageHelper.storeUserImage(
            image: serviceCategoryController.image!, name: fullName!);
      }

      Map<String, dynamic> data = {
        'name': fullName,
        'contact': contactNo,
        'address': address,
        'DOB': date,
        'imageURL': (serviceCategoryController.image != null)
            ? Global.imageURL
            : Global.currentUser!['imageURL'],
      };

      await CloudFirestoreHelper.cloudFirestoreHelper
          .updateUsersRecords(id: Global.currentUser!['email'], data: data);

      successSnackBar(
          msg: "Profile record successfully updated", context: context);

      fullNameController.clear();
      phoneController.clear();
      addressController.clear();

      fullName = null;
      contactNo = null;
      address = null;

      Get.offAndToNamed('/user_home_page');
    }
  }
}
