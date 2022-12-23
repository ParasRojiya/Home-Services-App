import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_services_app/controllers/worker_controller.dart';
import '../../global/snack_bar.dart';
import 'package:get/get.dart';
import '../../global/global.dart';
import '../../global/text_field_decoration.dart';
import '../../helper/cloud_firestore_helper.dart';
import '../../helper/cloud_storage_helper.dart';
import '../../global/button_syle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final TextEditingController workerExperienceController =
      TextEditingController();

  String? workerName;
  String? workerEmail;
  int? workerMobileNumber;
  int? workerHourlyPrice;
  String? workerExperience;

  File? image;
  XFile? pickedImage;

  final WorkerController workerController = Get.put(WorkerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    if (res != null) {
      workerName = res.id;
      workerNameController.text = res['name'];
      workerEmailController.text = res['email'];
      workerMobileNumberController.text = res['number'].toString();
      workerHourlyPriceController.text = res['price'].toString();
      workerExperienceController.text = res['experience'];
    }
    return Scaffold(
      appBar: AppBar(
        title: (res != null)
            ? const Text("Update Worker")
            : const Text("Add New Worker"),
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
                  spreadRadius: 4),
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
                        : null,
                    onSaved: (val) {
                      workerMobileNumber = int.parse(val!);
                    },
                    decoration: textFieldDecoration(
                        name: "Mobile Number", icon: Icons.eighteen_mp)),
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
                TextFormField(
                    controller: workerExperienceController,
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter worker experience"
                        : null,
                    onSaved: (val) {
                      workerExperience = val!;
                    },
                    decoration: textFieldDecoration(
                        name: "Worker Experience", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width:
                          (res != null) ? Get.width * 0.75 : Get.width * 0.90,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              workerController.image != null) {
                            formKey.currentState!.save();

                            await CloudStorageHelper.cloudStorageHelper
                                .storeWorkerImage(
                                    image: workerController.image!,
                                    name: workerName!);

                            Map<String, dynamic> data = {
                              'name': workerName!,
                              'email': workerEmail,
                              'number': workerMobileNumber,
                              'price': workerHourlyPrice,
                              'experience': workerExperience,
                              'imageURL': Global.imageURL,
                            };

                            (res != null)
                                ? await CloudFirestoreHelper
                                    .cloudFirestoreHelper
                                    .updateWorker(
                                        name: workerName!.toLowerCase(),
                                        data: data)
                                : await CloudFirestoreHelper
                                    .cloudFirestoreHelper
                                    .addWorker(
                                        name: workerName!
                                            .toLowerCase(), //serviceCategoryController.dropDownVal!,
                                        data: data);

                            successSnackBar(
                                msg: "Worker successfully added in database",
                                context: context);

                            workerNameController.clear();
                            workerEmailController.clear();
                            workerMobileNumberController.clear();
                            workerHourlyPriceController.clear();
                            workerExperienceController.clear();

                            workerName = null;
                            workerEmail = null;
                            workerMobileNumber = null;
                            workerHourlyPrice = null;
                            workerExperience = null;
                            Get.back();
                          } else if (workerController.image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please add image"),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: elevatedButtonStyle(),
                        child: (res != null)
                            ? const Text("Update Worker")
                            : const Text("Add Worker"),
                      ),
                    ),
                    (res != null)
                        ? FloatingActionButton(
                            onPressed: () {
                              deleteWorker();
                            },
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.delete),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteWorker() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Are you sure want to delete ${workerNameController.text}'s data ?",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
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
                  await CloudFirestoreHelper.cloudFirestoreHelper
                      .deleteWorker(name: workerName!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "${workerNameController.text}'s data deleted successfully"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Get.offNamedUntil('/', (route) => false);
                },
                child: Text(
                  "Delete",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          );
        });
  }
}
