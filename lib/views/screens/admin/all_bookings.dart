import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';

class AllBookings extends StatelessWidget {
  const AllBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Bookings"),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: CloudFirestoreHelper.cloudFirestoreHelper.fetchAllBookings(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot? document = snapshot.data;
              List<QueryDocumentSnapshot> documents = document!.docs;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, i) {
                  return Container(
                    width: Get.width,
                    height: 140,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black)),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text("${documents[i]['customerName']}"),
                        Text("${documents[i]['serviceName']}"),
                      ],
                    ),
                  );
                },
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
