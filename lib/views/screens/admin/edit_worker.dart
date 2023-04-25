import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/worker_controller.dart';
import '../../../global/button_syle.dart';
import '../../../global/global.dart';
import '../../../global/snack_bar.dart';
import '../../../global/text_field_decoration.dart';
import '../../../helper/cloud_firestore_helper.dart';
import '../../../helper/cloud_storage_helper.dart';

class EditWorker extends StatefulWidget {
  const EditWorker({Key? key}) : super(key: key);

  @override
  State<EditWorker> createState() => _EditWorkerState();
}

class _EditWorkerState extends State<EditWorker> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController workerNameController = TextEditingController();
  final TextEditingController workerEmailController = TextEditingController();
  final TextEditingController workerMobileNumberController =
      TextEditingController();
  final TextEditingController workerHourlyPriceController =
      TextEditingController();

  String? workerName;
  String? workerEmail;
  int? workerMobileNumber;
  int? workerHourlyPrice;
  String? gender;

  bool genderUpdated = false;
  bool categoryUpdated = false;

  String category = "AC Services";
  List dropDownValues = [
    "AC Services",
    "Cleaning",
    "Electronics",
    "Furniture",
    "Gardening",
    "Kitchen Appliances",
    "Painting",
    "Pest Control",
    "Plumbing",
    "Renovation",
    "Shifting",
    "Solar Consultant",
    "Vehicles",
    "More",
  ];

  File? image;
  XFile? pickedImage;

  final WorkerController workerController = Get.put(WorkerController());

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    workerName = res['name'];
    workerNameController.text = res['name'];
    workerEmailController.text = res['email'];
    workerMobileNumberController.text = res['number'].toString();
    workerHourlyPriceController.text = res['hourlyCharge'].toString();

    if (categoryUpdated == false) {
      category = res['category'];
    }
    if (genderUpdated == false) {
      gender = res['gender'];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Worker"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 4,
              ),
            ]),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                GetBuilder(
                  builder: (WorkerController controller) => CircleAvatar(
                    radius: 70,
                    backgroundImage: (res != null)
                        ? NetworkImage(res['imageURL'])
                        : (controller.image != null)
                            ? FileImage(controller.image!) as ImageProvider
                            : null,
                    backgroundColor: Colors.grey,
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
                                      workerController
                                          .addImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                      res = null;
                                    },
                                    child: const Text("Gallery")),
                                ElevatedButton(
                                    onPressed: () async {
                                      workerController
                                          .addImage(ImageSource.camera);
                                      Navigator.of(context).pop();
                                      res = null;
                                    },
                                    child: const Text("Camera")),
                              ],
                            );
                          });
                    },
                    child: (res != null)
                        ? const Text("Update Image")
                        : const Text("Add Image")),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(height: 14),
                TextFormField(
                    controller: workerNameController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter worker name" : null,
                    onSaved: (val) {
                      workerName = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Worker Name", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: workerEmailController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter worker Email" : null,
                    onSaved: (val) {
                      workerEmail = val!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: textFieldDecoration(
                        name: "Worker Email", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: workerMobileNumberController,
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter worker mobile number"
                        : (val!.length != 10)
                            ? "Mobile number length must by 10 numbers"
                            : null,
                    onSaved: (val) {
                      workerMobileNumber = int.parse(val!);
                    },
                    decoration: textFieldDecoration(
                        name: "Mobile Number", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      "Gender: ",
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Radio(
                        value: "Male",
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        }),
                    Text(
                      "Male",
                      style: GoogleFonts.ubuntu(),
                    ),
                    const SizedBox(width: 12),
                    Radio(
                        value: "Female",
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        }),
                    Text(
                      "Female",
                      style: GoogleFonts.ubuntu(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      "Category: ",
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    DropdownButton(
                        value: category,
                        items: dropDownValues.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            category = val as String;
                          });
                        })
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                    controller: workerHourlyPriceController,
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter worker hourly price"
                        : null,
                    onSaved: (val) {
                      workerHourlyPrice = int.parse(val!);
                    },
                    decoration: textFieldDecoration(
                        name: "Hourly Price", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: Get.width * 0.90,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            if (workerController.image != null) {
                              await CloudStorageHelper.cloudStorageHelper
                                  .storeWorkerImage(
                                      image: workerController.image!,
                                      name: workerName!);
                            }

                            Map<String, dynamic> data = {
                              'name': workerName!,
                              'email': workerEmail,
                              'number': workerMobileNumber,
                              'hourlyCharge': workerHourlyPrice,
                              'imageURL': (workerController.image != null)
                                  ? Global.imageURL
                                  : res['imageURL'],
                              'gender': gender,
                              'category': category,
                            };

                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateWorker(
                                    name:
                                        workerEmail!, //serviceCategoryController.dropDownVal!,
                                    data: data);

                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateUsersRecords(
                                    id: workerEmail!, data: data);

                            successSnackBar(
                                msg: "Worker successfully updated...",
                                context: context);

                            workerNameController.clear();
                            workerEmailController.clear();
                            workerMobileNumberController.clear();
                            workerHourlyPriceController.clear();

                            workerName = null;
                            workerEmail = null;
                            workerMobileNumber = null;
                            workerHourlyPrice = null;

                            Get.offNamedUntil("/all_workers", (route) => false);
                          }
                        },
                        style: elevatedButtonStyle(),
                        child: const Text("Update Worker"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
