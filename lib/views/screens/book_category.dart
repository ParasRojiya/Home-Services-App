import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';

import '../../global/global.dart';

TextStyle txtStyle = GoogleFonts.poppins(
  fontSize: 16,
);

class BookCategory extends StatelessWidget {
  const BookCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book ${res['name']}",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: NetworkImage(res['imageURL']),
              radius: 85,
            ),
            const SizedBox(height: 20),
            Text(
              res['name'],
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: Rs.${res['price']}",
              style: txtStyle,
            ),
            Text(
              "Duration: ${res['duration']}",
              style: txtStyle,
            ),
            Text(
              "Discount: ${res['discount']}%",
              style: txtStyle,
            ),
            Text(
              "${res['desc']}",
              style: txtStyle,
            ),
            ElevatedButton(
                onPressed: () async {
                  //  Global.cart = Global.currentUser!['cart'];
                  Map<String, dynamic> category = {
                    'desc': res['desc'],
                    "name": res['name'],
                    'discount': res['discount'],
                    'duration': res['duration'],
                    'price': res['price'],
                    'imageURL': res['imageURL'],
                  };
                  Global.cart.add(category);
                  print("============================================");
                  print(Global.cart);
                  print("============================================");

                  Map<String, dynamic> data = {
                    'cart': Global.cart,
                  };
                  await CloudFirestoreHelper.cloudFirestoreHelper
                      .updateUsersRecords(
                          id: Global.currentUser!['email'], data: data);

                  await CloudFirestoreHelper.firebaseFirestore
                      .collection('users')
                      .doc(Global.currentUser!['email'])
                      .snapshots()
                      .forEach((element) async {
                    Global.currentUser = {
                      'name': element.data()?['name'],
                      'email': element.data()?['email'],
                      'password': element.data()?['password'],
                      'role': element.data()?['role'],
                      'cart': element.data()?['cart'],
                    };
                  });
                  //Global.cart = Global.currentUser!['cart'];
                },
                child: Text("Add To Cart"))
          ],
        ),
      ),
    );
  }
}
