import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helper/cloud_firestore_helper.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List banner = ['b-1.jpeg', 'b-2.jpeg', 'b-3.jpeg', 'b-4.jpeg', 'b-5.jpeg'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping',
          style: GoogleFonts.habibi(fontSize: 18, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Icon(CupertinoIcons.search),
                const SizedBox(width: 10),
                Text(
                  'Search',
                  style:
                      GoogleFonts.habibi(fontSize: 17, color: Colors.black54),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayCurve: Curves.easeInOutExpo,
              viewportFraction: 1,
              height: 180.0,
            ),
            items: banner.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/$i'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            height: 180,
            width: Get.width,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: CloudFirestoreHelper.cloudFirestoreHelper
                .fetchShoppingRecords(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                QuerySnapshot? document = snapshot.data;
                List<QueryDocumentSnapshot> documents = document!.docs;
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigo, width: 1.2),
                  ),
                  child: const Text('Recommended'),
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 105,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigo, width: 1.2),
                  ),
                  child: const Text('Ac Services'),
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigo, width: 1.2),
                  ),
                  child: const Text('Cleaning'),
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigo, width: 1.2),
                  ),
                  child: const Text('Electronics'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
