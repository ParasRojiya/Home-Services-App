import 'package:flutter/material.dart';
import 'package:home_services_app/global/global.dart';
import 'package:get/get.dart';
import '../../helper/cloud_firestore_helper.dart';
import '../../widgets/category_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 220,
                ),
                itemCount: documents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  return categoryContainer(
                      categoryName: documents[i].id,
                      imageURL: documents[i]['imageURL']);
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
      floatingActionButton: (Global.isAdmin)
          ? FloatingActionButton(
              onPressed: () {
                Get.toNamed('/add_service');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
