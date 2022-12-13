import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference userRef;
  late CollectionReference categoryRef;

  //CATEGORIES COLLECTION HELPER
  connectionWithCategoryCollection() {
    categoryRef = firebaseFirestore.collection('categories');
  }

  Future<void> addCategory(
      {required String name, required Map<String, dynamic> data}) async {
    connectionWithCategoryCollection();
    categoryRef.doc(name).set(data);
  }

  Future<void> updateCategory(
      {required String name, required Map<String, dynamic> data}) async {
    connectionWithCategoryCollection();
    await categoryRef.doc(name).update(data);
  }

  Future<void> deleteCategory({required String name}) async {
    connectionWithCategoryCollection();
    await categoryRef.doc(name).delete();
  }

  Stream<QuerySnapshot> fetchAllCategories() {
    connectionWithCategoryCollection();
    return categoryRef.snapshots();
  }

  //USERS COLLECTION HELPER
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

  Future<void> updateRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectionWithUsersCollection();

    userRef.doc(id).update(data);
  }

  Future<void> deleteRecords({required String id}) async {
    connectionWithUsersCollection();

    userRef.doc(id).delete();
  }
}
