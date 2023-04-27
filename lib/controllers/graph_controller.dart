import 'package:get/get.dart';

class GraphController extends GetxController {
  RxList data = [].obs;

  updateData({required List dummy}) {
    data = dummy.obs;
  }
}
