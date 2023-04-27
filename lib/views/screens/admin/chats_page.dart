import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inbox",
          style: GoogleFonts.habibi(fontSize: 20, color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectChatRecords(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? document = snapshot.data;
            List<QueryDocumentSnapshot> documents = document!.docs;

            return StreamBuilder<QuerySnapshot>(
              stream: CloudFirestoreHelper.cloudFirestoreHelper
                  .selectUsersRecords(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                } else if (snapshot.hasData) {
                  QuerySnapshot? document = snapshot.data;
                  List userDocument = document!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, i) {
                      List chat = documents[i]['chats'];
                      String msg = (chat.isEmpty)
                          ? 'No Message Yet...'
                          : '${chat.last['message']}';
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/chat_page', arguments: documents[i].id);
                        },
                        child: SizedBox(
                          height: 100,
                          width: Get.width,
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          userDocument[i]['imageURL'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userDocument[i]['name'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            size: 20,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${userDocument[i]['role']}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.chat_bubble_2,
                                            size: 20,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${msg}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      CupertinoIcons.phone_fill_arrow_up_right,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
