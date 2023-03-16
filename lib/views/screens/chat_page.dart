import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_apk/helper/FireStoreHelper.dart';
import 'package:firebase_apk/helper/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modal.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: GoogleFonts.habibi(fontSize: 18, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthHelper.firebaseAuthHelper.logOutUser();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login_page', (route) => false);
            },
            icon: const Icon(
              Icons.logout,
              size: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FireStoreHelper.fireStoreHelper.fetchMessage(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("something is wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  itemCount: snapshot.data!.docs.length,
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  shrinkWrap: false,
                  primary: false,
                  itemBuilder: (_, index) {
                    index = snapshot.data!.docs.length - 1 - index;
                    QueryDocumentSnapshot data = snapshot.data!.docs[index];
                    Timestamp time = data['time'];
                    DateTime date = time.toDate();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: Modal.email == data['email']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250,
                            child: ListTile(
                              tileColor: (Modal.email == data['email'])
                                  ? Colors.indigo.shade300
                                  : Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  data['email'],
                                  style: GoogleFonts.balooBhai2(
                                    fontSize: 15,
                                    color: (Modal.email == data['email'])
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    width: 160,
                                    child: Text(
                                      data['message'],
                                      softWrap: true,
                                      style: GoogleFonts.balooBhai2(
                                        fontSize: 18,
                                        height: 1,
                                        color: (Modal.email == data['email'])
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' ${date.hour.toString()} : ${date.minute.toString()}',
                                    style: GoogleFonts.balooBhai2(
                                      fontSize: 16,
                                      height: 1,
                                      color: (Modal.email == data['email'])
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                        Map<String, dynamic> data = {
                          'message': msg.text.trim(),
                          'time': DateTime.now(),
                          'email': Modal.email,
                        };

                        DocumentReference docRef = await FireStoreHelper
                            .fireStoreHelper
                            .message(data: data);

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
