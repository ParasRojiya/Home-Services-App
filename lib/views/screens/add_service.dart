import 'dart:io';

import 'package:flutter/material.dart';
import '../../global/snack_bar.dart';
import 'package:get/get.dart';
import '../../global/global.dart';
import '../../global/text_field_decoration.dart';
import '../../controllers/service_category_controller.dart';
import '../../helper/cloud_firestore_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helper/cloud_storage_helper.dart';
import '../../global/button_syle.dart';
import 'package:image_picker/image_picker.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryPriceController = TextEditingController();
  final TextEditingController categoryDurationController =
      TextEditingController();
  final TextEditingController categoryDiscountController =
      TextEditingController();
  final TextEditingController categoryDescriptionController =
      TextEditingController();

  String? categoryName;
  int? categoryPrice;
  String? categoryDuration;
  String? categoryDescription;
  String? categoryDiscount;

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
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    if (res != null) {
      categoryNameController.text = res['name'];
      categoryPriceController.text = res['price'].toString();
      categoryDurationController.text = res['duration'];
      categoryDiscountController.text = res['discount'];
      categoryDescriptionController.text = res['desc'];
    }
    return Scaffold(
      appBar: AppBar(
        title: (res != null)
            ? const Text("Update Category")
            : const Text("Add New Category"),
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
                                      serviceCategoryController
                                          .addImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                      res = null;
                                    },
                                    child: const Text("Gallery")),
                                ElevatedButton(
                                    onPressed: () async {
                                      serviceCategoryController
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
                    controller: categoryNameController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter  category name" : null,
                    onSaved: (val) {
                      categoryName = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Category Name", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: categoryPriceController,
                    validator: (val) =>
                        (val!.isEmpty) ? "Please enter  category name" : null,
                    onSaved: (val) {
                      categoryPrice = int.parse(val!);
                    },
                    decoration: textFieldDecoration(
                        name: "Category Price", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: categoryDurationController,
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter  category duration"
                        : null,
                    onSaved: (val) {
                      categoryDuration = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Category Duration", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: categoryDiscountController,
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter  category discount"
                        : null,
                    onSaved: (val) {
                      categoryDiscount = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Category Discount", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                TextFormField(
                    controller: categoryDescriptionController,
                    maxLines: 5,
                    validator: (val) => (val!.isEmpty)
                        ? "Please enter  category description"
                        : null,
                    onSaved: (val) {
                      categoryDescription = val;
                    },
                    decoration: textFieldDecoration(
                        name: "Category Description", icon: Icons.eighteen_mp)),
                const SizedBox(height: 12),
                Container(
                  width: Get.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          serviceCategoryController.image != null) {
                        formKey.currentState!.save();

                        await CloudStorageHelper.cloudStorageHelper
                            .storeServiceImage(
                                image: serviceCategoryController.image!,
                                name: categoryName!);

                        Map<String, dynamic> data = {
                          'name': categoryName!,
                          'price': categoryPrice,
                          'duration': categoryDuration,
                          'discount': categoryDiscount,
                          'desc': categoryDescription,
                          'imageURL': Global.imageURL,
                        };

                        (res != null)
                            ? await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateService(
                                    name: categoryName!.toLowerCase(),
                                    data: data)
                            : await CloudFirestoreHelper.cloudFirestoreHelper
                                .addService(
                                    name: categoryName!
                                        .toLowerCase(), //serviceCategoryController.dropDownVal!,
                                    data: data);

                        successSnackBar(
                            msg: "Category successfully added in database",
                            context: context);

                        categoryNameController.clear();
                        categoryPriceController.clear();
                        categoryDurationController.clear();
                        categoryDiscountController.clear();
                        categoryDescriptionController.clear();

                        categoryName = null;
                        categoryPrice = null;
                        categoryDuration = null;
                        categoryDiscount = null;
                        categoryDescription = null;
                      } else if (serviceCategoryController.image == null) {
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
                        ? const Text("Update Category")
                        : const Text("Add Category"),
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
