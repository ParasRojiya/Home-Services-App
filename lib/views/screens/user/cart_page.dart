import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/controllers/cart_controller.dart';

import '../../../global/global.dart';
import '../../../helper/cloud_firestore_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List data = Global.cart;

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        alignment: Alignment.center,
        child: (Global.cart.isEmpty)
            ? Text("Cart is Empty")
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        // Argument args = Argument(
                        //   i: i,
                        //   fullData: res,
                        //   ids: id,
                        //   currentData: data[i],
                        // );
                        // (Global.isAdmin)
                        //     ? Get.toNamed('/edit_service_page', arguments: args)
                        //     : Get.toNamed('/book_service', arguments: args);
                      },
                      child: Card(
                        elevation: 2,
                        child: Container(
                          height: 120,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 8),
                              Center(
                                child: Container(
                                  height: 105,
                                  width: 115,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(data[i]['imageURL']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 11),
                                  Text(
                                    data[i]['name'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.indigo),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹ ${data[i]['price']}',
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Duration: ${data[i]['duration']} Min.',
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    '${ratings(ratings: data[i]['ratings'])} ⭐   |    ${data[i]['ratings'].length} Reviews',
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon((Global.cart.isEmpty)
                                    ? Icons.shopping_cart_outlined
                                    : cartIcon(deta: data[i])),
                                onPressed: () async {
                                  setState(() {
                                    addToCart(i: i, data: data);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  double ratings({required List ratings}) {
    double rating = 0;
    for (var map in ratings) {
      rating += map['rating'];
    }
    rating = rating / 5;
    return rating;
  }

  cartIcon({required deta}) {
    for (int i = 0; i < Global.cart.length; i++) {
      if (Global.cart[i]['name'] == deta['name']) {
        return Icons.remove_shopping_cart_outlined;
      } else {
        return Icons.shopping_cart_outlined;
      }
    }
  }

  addToCart({required int i, required data}) async {
    int counterA = 0;
    int index = 0;
    NINJA:
    for (int j = 0; j < Global.cart.length; j++) {
      if (Global.cart[j]['name'] == data[i]['name']) {
        counterA++;
        break NINJA;
      }
      index++;
    }

    print(counterA);
    print(index);

    if (counterA == 0) {
      print("Isn't in cart");

      Global.cart.add(data[i]);

      Map<String, dynamic> dete = {
        'cart': Global.cart,
      };

      await CloudFirestoreHelper.cloudFirestoreHelper
          .updateUsersRecords(id: Global.currentUser!['email'], data: dete);

      Get.snackbar("Added to cart", "${data[i]['name']} added to cart");
      cartController.addToCart(Global.cart.length);
    } else if (counterA == 1) {
      print("Is in cart");
      Global.cart.removeAt(index);

      Map<String, dynamic> dete = {
        'cart': Global.cart,
      };

      await CloudFirestoreHelper.cloudFirestoreHelper
          .updateUsersRecords(id: Global.currentUser!['email'], data: dete);

      Get.snackbar("Removed from cart", "${data[i]['name']} removed from cart");
      cartController.addToCart(Global.cart.length);
    }
  }
}
