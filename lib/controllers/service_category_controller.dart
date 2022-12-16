import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ServiceCategoryController extends GetxController {
  String? dropDownVal;
  XFile? pickedImage;
  File? image;

  selectCategory(String category) {
    dropDownVal = category;
    update();
  }

  addImage() {
    image = File(pickedImage!.path);
    update();
  }
}
