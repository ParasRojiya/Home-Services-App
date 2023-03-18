import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WorkerController extends GetxController {
  // String? dropDownVal;
  XFile? pickedImage;
  File? image;
  final ImagePicker _picker = ImagePicker();

  // selectCategory(String category) {
  //   dropDownVal = category;
  //   update();
  // }

  addImage(ImageSource source) async {
    pickedImage = await _picker.pickImage(source: source, imageQuality: 50);

    image = File(pickedImage!.path);
    update();
  }
}
