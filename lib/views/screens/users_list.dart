import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/cloud_firestore_helper.dart';
import '../../helper/firebase_auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../global/global.dart';

class UsersList extends StatelessWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
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
                        "${documents[i].id}\nRole:- ${documents[i]['role']}",
                        style: GoogleFonts.poppins(),
                      ),
                      trailing: Switch(
                        value: documents[i]['isActive'],
                        onChanged: (val) async {
                          if (Global.currentUser!['email'] == documents[i].id) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "You can't disable your account",
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            Map<String, dynamic> data = {
                              "isActive": !documents[i]['isActive'],
                            };
                            await CloudFirestoreHelper.cloudFirestoreHelper
                                .updateUsersRecords(
                                    id: documents[i].id, data: data);

                            if (documents[i]['isActive']) {
                              await FireBaseAuthHelper.fireBaseAuthHelper
                                  .deleteUser(
                                      email: documents[i]['email'],
                                      password: documents[i]['password']);
                            } else {
                              await FireBaseAuthHelper.fireBaseAuthHelper
                                  .signUp(
                                      email: documents[i]['email'],
                                      password: documents[i]['password']);
                            }
                          }
                        },
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
      ),
    );
  }
}
