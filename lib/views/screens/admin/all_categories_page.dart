import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../helper/cloud_firestore_helper.dart';
import '../../../widgets/category_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List color = [
  Colors.blue.withOpacity(0.1),
  Colors.green.withOpacity(0.1),
  Colors.indigo.withOpacity(0.1),
  Colors.orangeAccent.withOpacity(0.1),
  Colors.teal.withOpacity(0.1),
  Colors.grey.withOpacity(0.1),
  Colors.brown.withOpacity(0.1),
  Colors.amber.withOpacity(0.1),
  Colors.pink.withOpacity(0.1),
  Colors.cyan.withOpacity(0.1),
  Colors.purple.withOpacity(0.1),
  Colors.blueAccent.withOpacity(0.1),
  Colors.redAccent.withOpacity(0.1),
  Colors.blueGrey.withOpacity(0.1),
];

class AllCategories extends StatelessWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        title: Text(
          "Categories",
          style: GoogleFonts.habibi(),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              CloudFirestoreHelper.cloudFirestoreHelper.fetchAllCategories(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot? document = snapshot.data;
              List<QueryDocumentSnapshot> documents = document!.docs;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 5,
                  mainAxisExtent: 110,
                ),
                itemCount: documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed('/all_services_page',
                          arguments: documents[i]);
                    },
                    child: categoryContainer(
                        color: color[i],
                        categoryName: documents[i]['name'],
                        imageURL: documents[i]['imageURL']),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
