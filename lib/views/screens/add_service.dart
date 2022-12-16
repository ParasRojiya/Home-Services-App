import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global/text_field_decoration.dart';
import '../../controllers/service_category_controller.dart';
import '../../helper/cloud_firestore_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../global/button_syle.dart';
import 'package:image_picker/image_picker.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController servicePriceController = TextEditingController();
  final TextEditingController serviceDurationController =
      TextEditingController();
  final TextEditingController serviceDiscountController =
      TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();

  String? serviceName;
  int? servicePrice;
  String? serviceDuration;
  String? serviceDescription;
  String? serviceDiscount;

  final ImagePicker _picker = ImagePicker();
  File? image;
  XFile? pickedImage;

  final ServiceCategoryController serviceCategoryController =
      Get.put(ServiceCategoryController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        ? FileImage(controller.image!)
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
                                      serviceCategoryController.pickedImage =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);

                                      serviceCategoryController.addImage();

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Gallery")),
                                ElevatedButton(
                                    onPressed: () async {
                                      serviceCategoryController.pickedImage =
                                          await _picker.pickImage(
                                              source: ImageSource.camera);

                                      serviceCategoryController.addImage();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Select Category: -",
                      style: GoogleFonts.poppins(),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: CloudFirestoreHelper.cloudFirestoreHelper
                          .fetchAllCategories(),
                      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                        QuerySnapshot? document = snapshot.data;
                        List<QueryDocumentSnapshot> data = document!.docs;
                        return GetBuilder<ServiceCategoryController>(
                          builder: (ServiceCategoryController controller) =>
                              DropdownButton(
                            items: // controller.items
                                data
                                    .map((e) => DropdownMenuItem(
                                          value: e.id,
                                          child: Text(e.id),
                                        ))
                                    .toList(),
                            value: controller.dropDownVal,
                            onChanged: (val) {
                              controller.selectCategory(val.toString());
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
                TextFormField(
                    controller: serviceDurationController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter service duration" : null,
                    onSaved: (val) {
                      serviceDuration = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Service Duration", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: serviceDiscountController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter service discount" : null,
                    onSaved: (val) {
                      serviceDiscount = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Service Discount", icon: Icons.eighteen_mp)),
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
                  width: Get.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {},
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
}
