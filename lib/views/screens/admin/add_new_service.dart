import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/service_category_controller.dart';
import '../../../global/button_syle.dart';
import '../../../global/global.dart';
import '../../../global/snack_bar.dart';
import '../../../global/text_field_decoration.dart';
import '../../../helper/cloud_firestore_helper.dart';
import '../../../helper/cloud_storage_helper.dart';

class AddNewService extends StatefulWidget {
  const AddNewService({Key? key}) : super(key: key);

  @override
  State<AddNewService> createState() => _AddNewServiceState();
}

class _AddNewServiceState extends State<AddNewService> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDurationController =
      TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();

  String? serviceName;
  int? servicePrice;
  String? serviceDuration;
  String? serviceDescription;

  File? image;
  XFile? pickedImage;

  final ServiceCategoryController serviceCategoryController =
      Get.put(ServiceCategoryController());

  String id = '';
  List? data;

  int? duration;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot res =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;
    id = res.id;
    data = res['services'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Service"),
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
                  builder: (ServiceCategoryController controller) =>
                      CircleAvatar(
                    radius: 70,
                    backgroundImage: (controller.image != null)
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
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(height: 14),
                TextFormField(
                    controller: serviceNameController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter service name" : null,
                    onSaved: (val) {
                      serviceName = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Service Name", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: servicePriceController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter service name" : null,
                    onSaved: (val) {
                      servicePrice = int.parse(val!);
                    },
                    decoration: textFieldDecoration(
                        name: "Service Price", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      "Duration: ",
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Radio(
                        value: 30,
                        groupValue: duration,
                        onChanged: (val) {
                          setState(() {
                            duration = val;
                          });
                        }),
                    Text(
                      "30 Min",
                      style: GoogleFonts.ubuntu(),
                    ),
                    const SizedBox(width: 12),
                    Radio(
                        value: 60,
                        groupValue: duration,
                        onChanged: (val) {
                          setState(() {
                            duration = val;
                          });
                        }),
                    Text(
                      "1 Hr",
                      style: GoogleFonts.ubuntu(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                    controller: serviceDescriptionController,
                    maxLines: 5,
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter service description"
                        : null,
                    onSaved: (val) {
                      serviceDescription = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Service Description", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                Container(
                  width: Get.width * 0.90,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      addService();
                    },
                    style: elevatedButtonStyle(),
                    child: const Text("Add Service"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addService() async {
    if (formKey.currentState!.validate() &&
        serviceCategoryController.image != null) {
      formKey.currentState!.save();

      await CloudStorageHelper.cloudStorageHelper.storeServiceImage(
          image: serviceCategoryController.image!, name: serviceName!);

      Map<String, dynamic> dota = {
        'name': serviceName!,
        'price': servicePrice,
        'duration': duration,
        'desc': serviceDescription,
        'imageURL': Global.imageURL,
      };

      data?.add(dota);

      Map<String, dynamic> teda = {
        'services': data,
      };

      await CloudFirestoreHelper.cloudFirestoreHelper
          .updateService(name: id, data: teda);

      successSnackBar(
          msg: "Service successfully added in database", context: context);

      serviceNameController.clear();
      servicePriceController.clear();
      serviceDurationController.clear();
      serviceDescriptionController.clear();

      serviceName = null;
      servicePrice = null;
      serviceDuration = null;
      serviceDescription = null;

      Get.offAndToNamed('/all_categories');
    } else if (serviceCategoryController.image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add image"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
