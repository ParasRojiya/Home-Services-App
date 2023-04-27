import 'package:get/get.dart';

import '../global/global.dart';

class CartController extends GetxController {
  int length = Global.cart.length;

  addToCart(int cartlength) {
    length = cartlength;
    update();
  }
}
