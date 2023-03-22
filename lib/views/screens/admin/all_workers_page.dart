import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_app/global/global.dart';
import 'package:home_services_app/widgets/worker_container.dart';

import '../../../helper/cloud_firestore_helper.dart';

class AllWorkers extends StatelessWidget {
  const AllWorkers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workers"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: StreamBuilder<QuerySnapshot>(
          stream: CloudFirestoreHelper.cloudFirestoreHelper.fetchAllWorker(),
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
                  return InkWell(
                    onTap: () {
                      (Global.isAdmin)
                          ? Get.toNamed('/edit_worker', arguments: documents[i])
                          : Get.toNamed('/worker_details',
                              arguments: documents[i]);
                    },
                    child: workerContainer(
                        hourlyCharge: documents[i]['hourlyCharge'],
                        name: documents[i]['name'],
                        imageURL: documents[i]['imageURL'],
                        number: documents[i]['number'],
                        service: documents[i]['category']
                        // imageURL: "",
                        ),
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
      floatingActionButton: (Global.isAdmin)
          ? FloatingActionButton.extended(
              onPressed: () {
                Get.toNamed('/add_worker');
              },
              label: const Text("Add Worker"),
            )
          : null,
    );
  }
}
