import 'dart:io';

import 'package:flutter/material.dart';
import '../../../global/snack_bar.dart';
import 'package:get/get.dart';
import '../../../global/global.dart';
import '../../../global/text_field_decoration.dart';
import '../../../controllers/service_category_controller.dart';
import '../../../helper/cloud_firestore_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../helper/cloud_storage_helper.dart';
import '../../../global/button_syle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'all_services_page.dart';

class EditService extends StatefulWidget {
  const EditService({Key? key}) : super(key: key);

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
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

  Argument? res;
  List? list;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    res = ModalRoute.of(context)!.settings.arguments as Argument;
    list = res?.fullData['services'];
    String? id = res?.ids;
    Map<String, dynamic>? currentData = res?.currentData;


      serviceName = currentData!['name'];
      serviceNameController.text = currentData['name'];
      servicePriceController.text = currentData['price'].toString();
      serviceDurationController.text = currentData['duration'];
      serviceDescriptionController.text = currentData['desc'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Service"),
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
                            : NetworkImage(currentData['imageURL']),
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
                    child: const Text("Edit Image")),
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
                    onPressed: () {
                      updateService();
                    },
                    style: elevatedButtonStyle(),
                    child: const Text("Edit Service"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteService() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Are you sure want to delete the ${serviceNameController.text} service?",
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
                      .deleteCategory(name: serviceName!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "${serviceNameController.text} deleted successfully"),
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

  updateService() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if(serviceCategoryController.image != null) {
        await CloudStorageHelper.cloudStorageHelper
            .storeServiceImage(
            image: serviceCategoryController.image!,
            name: serviceName!);
      }

      Map<String, dynamic> editedData = {
        'name': serviceName,
        'price': servicePrice,
        'duration': serviceDuration,
        'desc': serviceDescription,
        'imageURL': (serviceCategoryController.image != null) ?Global.imageURL: res!.currentData['imageURL'],
      };

      list!.removeAt(res!.i);
      list!.insert(res!.i, editedData);

      Map<String, dynamic> data = {
        'services':list,
      };

      await CloudFirestoreHelper.cloudFirestoreHelper.updateService(name: res!.ids, data:data);


      successSnackBar(
          msg: "Service successfully added in database",
          context: context);

      serviceNameController.clear();
      servicePriceController.clear();
      serviceDurationController.clear();
      serviceDescriptionController.clear();

      serviceName = null;
      servicePrice = null;
      serviceDuration = null;
      serviceDescription = null;

      Get.offAndToNamed('/all_categories_page');
    }
  }
}
