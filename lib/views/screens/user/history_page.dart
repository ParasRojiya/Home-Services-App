import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../global/global.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              CloudFirestoreHelper.cloudFirestoreHelper.selectUsersRecords(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot? document = snapshot.data;
              List<QueryDocumentSnapshot> documents = document!.docs;
              List cart = [];
              for (var users in documents) {
                if (users.id == Global.currentUser!['email']) {
                  cart = users['cart'];
                }
              }
              ;

              return ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text("${cart[i]['name']}"),
                      subtitle: Text("Rs. ${cart[i]['price']}"),
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
