import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../global/global.dart';
import '../../../helper/cloud_firestore_helper.dart';
import '../../../helper/firebase_auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRatingPage extends StatefulWidget {
  const ViewRatingPage({Key? key}) : super(key: key);

  @override
  State<ViewRatingPage> createState() => _ViewRatingPageState();
}

class _ViewRatingPageState extends State<ViewRatingPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "User's Rating & Review",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            return ListView.builder(
              itemCount: documents.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: Text(
                      "${documents[i]['name']}",
                      style: GoogleFonts.poppins(),
                    ),
                    subtitle: Text(
                      "${documents[i].id}\nRating:-${documents[i]['rate']}\nComment:-${documents[i]['comment']}",
                      style: GoogleFonts.poppins(),
                    ),
                    isThreeLine: true,
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
    );
  }
}
