import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference userRef;

  connectionWithUsersCollection() {
    userRef = firebaseFirestore.collection('users');
  }

  Future<void> insertDataInUsersCollection(
      {required Map<String, dynamic> data}) async {
    connectionWithUsersCollection();
    await userRef.doc(data["email"]).set(data);
  }

  Stream<QuerySnapshot<Object?>> selectUsersRecords() {
    connectionWithUsersCollection();

    return userRef.snapshots();
  }
  //
  // Future<void> updateRecords(
  //     {required String id, required Map<String, dynamic> data}) async {
  //   connectionWithUsersCollection();
  //
  //   userRef.doc(id).update(data);
  // }
  //
  // Future<void> deleteRecords({required String id}) async {
  //   connectionWithUsersCollection();
  //
  //   userRef.doc(id).delete();
  // }
}
