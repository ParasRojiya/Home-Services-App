import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  List category = [
    {'name': 'Recommended', 'width': 125.00},
    {'name': 'AC Services', 'width': 105.00},
    {'name': 'Cleaning', 'width': 85.00},
    {'name': 'Electronics', 'width': 110.00},
    {'name': 'Furniture', 'width': 110.00},
    {'name': 'Gardening', 'width': 100.00},
    {'name': 'Painting', 'width': 90.00},
    {'name': 'Plumbing', 'width': 90.00},
    {'name': 'Solar', 'width': 75.00},
  ];

  List data = [];
  int index = 0;

  String selectedCategory = 'Recommended';

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
          Row(
            children: [
              Text(
                "Most Popular Product",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.toNamed("/all_product", arguments: data);
                },
                style: TextButton.styleFrom(textStyle: GoogleFonts.poppins()),
                child: const Text(
                  "View all",
                  style: TextStyle(fontSize: 13),
                ),
              )
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: category
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = '${e['name']}';
                          index = category.indexOf(e);
                        });
                      },
                      child: categoryContainer(
                          name: '${e['name']}',
                          width: e['width'],
                          color: (selectedCategory == '${e['name']}')
                              ? Colors.indigo.withOpacity(0.2)
                              : Colors.transparent),
                    ),
                  )
                  .toList(),
            ),
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

                data = documents;
                return SizedBox(
                  height: 480,
                  width: Get.width,
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 225,
                    ),
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          _launchUrl(
                              url: documents[index]['products'][i]['link']);
                        },
                        child: Card(
                          margin: const EdgeInsets.all(0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Center(
                                  child: Container(
                                    height: 160,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(documents[index]
                                            ['products'][i]['imageURL']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: 100,
                                          child: Text(
                                            documents[index]['products'][i]
                                                ['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.habibi(
                                                fontSize: 16),
                                          ),
                                        ),
                                        Text(
                                          '₹ ${documents[index]['products'][i]['price']}',
                                          style:
                                              GoogleFonts.ubuntu(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.indigo.shade100,
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.shopping_bag,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  categoryContainer(
      {required String name, required double width, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(right: 7),
      alignment: Alignment.center,
      height: 35,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        border: Border.all(color: Colors.indigo, width: 1.2),
      ),
      child: Text(
        name,
        style: GoogleFonts.habibi(),
      ),
    );
  }

  Future<void> _launchUrl({required String url}) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
