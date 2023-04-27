import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global/global.dart';
import '../../../helper/cloud_firestore_helper.dart';
import '../../../helper/firebase_auth_helper.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> with TickerProviderStateMixin {
  late TabController tabController;
  int index = 0;
  PageController pageController = PageController();
  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        bottom: TabBar(
          onTap: (val) {
            setState(
              () {
                tabController.animateTo(val);
                initialIndex = val;
              },
            );
          },
          controller: tabController,
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 2.5,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(
              child: Text(
                'Users',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Workers',
                style: GoogleFonts.habibi(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: const BouncingScrollPhysics(),
        children: const [
          Users(),
          Workers(),
        ],
      ),
    );
  }
}

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: CloudFirestoreHelper.cloudFirestoreHelper.selectUsersRecords(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          QuerySnapshot? document = snapshot.data;
          List<QueryDocumentSnapshot> documents = document!.docs;
          List users = [];

          for (var user in documents) {
            if (user['role'] == 'user') {
              users.add(user);
            }
          }
          for (var user in documents) {
            if (user['role'] == 'worker') {
              //workers.add(user);
            }
          }

          // if (counter == 0) {
          //   data = users;
          //   counter++;
          //   data.toSet().toList();
          // }

          return ListView.builder(
            itemCount: users.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  title: Text(
                    "${users[i]['name']}",
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    "${users[i].id}\nRole:- ${users[i]['role']}",
                    style: GoogleFonts.poppins(),
                  ),
                  trailing: Switch(
                    value: users[i]['isActive'],
                    onChanged: (val) async {
                      if (Global.currentUser!['email'] == users[i]['email']) {
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
                        Map<String, dynamic> deta = {
                          "isActive": !users[i]['isActive'],
                        };
                        await CloudFirestoreHelper.cloudFirestoreHelper
                            .updateUsersRecords(id: users[i].id, data: deta);

                        if (users[i]['isActive']) {
                          await FireBaseAuthHelper.fireBaseAuthHelper
                              .deleteUser(
                                  email: users[i]['email'],
                                  password: users[i]['password']);
                        } else {
                          await FireBaseAuthHelper.fireBaseAuthHelper.signUp(
                              email: users[i]['email'],
                              password: users[i]['password']);
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
    );
  }
}

class Workers extends StatefulWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  State<Workers> createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: CloudFirestoreHelper.cloudFirestoreHelper.selectUsersRecords(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          QuerySnapshot? document = snapshot.data;
          List<QueryDocumentSnapshot> documents = document!.docs;
          List workers = [];

          for (var user in documents) {
            if (user['role'] == 'user') {
              // users.add(user);
            }
          }
          for (var user in documents) {
            if (user['role'] == 'worker') {
              workers.add(user);
            }
          }

          // if (counter == 0) {
          //   data = users;
          //   counter++;
          //   data.toSet().toList();
          // }

          return ListView.builder(
            itemCount: workers.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  title: Text(
                    "${workers[i]['name']}",
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    "${workers[i].id}\nRole:- ${workers[i]['role']}",
                    style: GoogleFonts.poppins(),
                  ),
                  trailing: Switch(
                    value: documents[i]['isActive'],
                    onChanged: (val) async {
                      if (Global.currentUser!['email'] == workers[i]['email']) {
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
                        Map<String, dynamic> deta = {
                          "isActive": !workers[i]['isActive'],
                        };
                        await CloudFirestoreHelper.cloudFirestoreHelper
                            .updateUsersRecords(id: workers[i].id, data: deta);

                        if (documents[i]['isActive']) {
                          await FireBaseAuthHelper.fireBaseAuthHelper
                              .deleteUser(
                                  email: workers[i]['email'],
                                  password: workers[i]['password']);
                        } else {
                          await FireBaseAuthHelper.fireBaseAuthHelper.signUp(
                              email: workers[i]['email'],
                              password: workers[i]['password']);
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
    );
  }
}
