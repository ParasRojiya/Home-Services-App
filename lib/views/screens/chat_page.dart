import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';

import '../../global/global.dart';
import '../../helper/fcm_helper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msg = TextEditingController();
  List chat = [];
  String? token;

  getToken({required String email}) async {
    await CloudFirestoreHelper.cloudFirestoreHelper
        .selectUsersRecords()
        .forEach((element) {
      List list = element.docs;

      for (var user in list) {
        if (user.id == email) {
          token = user['token'];
        }
      }
    });

    print("======================");
    print(token);
    print("======================");
  }

  @override
  void initState() {
    super.initState();
    if (Global.currentUser!['role'] == 'user') {
      getToken(email: "admin@gmail.com");
    }
  }

  @override
  Widget build(BuildContext context) {
    var res = ModalRoute.of(context)!.settings.arguments;
    if (Global.currentUser!['role'] == 'admin') {
      getToken(email: res as String);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Support',
          style: GoogleFonts.habibi(fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  CloudFirestoreHelper.cloudFirestoreHelper.selectChatRecords(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("something is wrong");
                } else if (snapshot.hasData) {
                  QuerySnapshot? document = snapshot.data;
                  List<QueryDocumentSnapshot> documents = document!.docs;
                  QueryDocumentSnapshot? chatList;
                  String email =
                      (res == null) ? Global.currentUser!['email'] : res;
                  documents.forEach((element) {
                    if (element.id == email) {
                      chatList = element;
                    }
                  });
                  chat = chatList!['chats'];
                  print("========================");
                  print(chat);
                  print("========================");

                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                    itemCount: chat.length,
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    shrinkWrap: false,
                    primary: false,
                    itemBuilder: (context, i) {
                      i = chat.length - 1 - i;
                      Map<String, dynamic> data = chat[i];
                      Timestamp time = data['time'];
                      DateTime date = time.toDate();

                      return (chat.isEmpty)
                          ? Text('Send message to start conversation...')
                          : Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment:
                                    Global.currentUser!['email'] ==
                                            data['email']
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  Bubble(
                                    margin: BubbleEdges.only(
                                      top: 10,
                                      right: (Global.currentUser!['email'] ==
                                              data['email'])
                                          ? 0
                                          : 80,
                                      left: (Global.currentUser!['email'] ==
                                              data['email'])
                                          ? 80
                                          : 0,
                                    ),
                                    nip: (Global.currentUser!['email'] ==
                                            data['email'])
                                        ? BubbleNip.rightTop
                                        : BubbleNip.leftTop,
                                    color: (Global.currentUser!['email'] ==
                                            data['email'])
                                        ? const Color(0xFF1B97F3)
                                        : Colors.grey.shade200,
                                    child: Stack(
                                      alignment:
                                          (Global.currentUser!['email'] ==
                                                  data['email'])
                                              ? Alignment.bottomRight
                                              : Alignment.bottomLeft,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 11),
                                          child: Text(
                                            data['message'],
                                            softWrap: true,
                                            style: GoogleFonts.balooBhai2(
                                              fontSize: 18,
                                              color: (Global.currentUser![
                                                          'email'] ==
                                                      data['email'])
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${date.hour.toString()}:${date.minute.toString()}',
                                          style: GoogleFonts.balooBhai2(
                                            fontSize: 12,
                                            height: 1,
                                            color:
                                                (Global.currentUser!['email'] ==
                                                        data['email'])
                                                    ? Colors.grey.shade300
                                                    : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
          Container(
            color: Colors.white,
            height: 70,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: msg,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple.withOpacity(0.05),
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      msg.text = value!;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade500, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () async {
                      if (msg.text.isNotEmpty) {
                        Map<String, dynamic> message = {
                          'message': msg.text.trim(),
                          'time': DateTime.now(),
                          'email': Global.currentUser!['email'],
                        };

                        chat.add(message);

                        Map<String, dynamic> data = {
                          'chats': chat,
                        };
                        await CloudFirestoreHelper.cloudFirestoreHelper
                            .insertChatRecords(
                                id: (res == null)
                                    ? Global.currentUser!['email']
                                    : res,
                                data: data);

                        FCMHelper.fcmHelper.sendNotification(
                            title: Global.currentUser!['email'],
                            body: msg.text,
                            token: token);

                        msg.clear();
                      }
                    },
                    icon: const Icon(
                      Icons.send_sharp,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
