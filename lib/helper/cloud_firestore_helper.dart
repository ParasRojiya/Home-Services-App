import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference userRef;
  late CollectionReference categoryRef;
  late CollectionReference workerRef;

  //CATEGORIES COLLECTION HELPER
  connectionWithCategoryCollection() {
    categoryRef = firebaseFirestore.collection('categories');
  }

  Future<void> addService(
      {required String name, required Map<String, dynamic> data}) async {
    connectionWithCategoryCollection();
    await categoryRef.doc(name).set(data);
  }

  Future<void> updateService(
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

  //WORKERS COLLECTION HELPER
  connectionWithWorkerCollection() {
    workerRef = firebaseFirestore.collection('workers');
  }

  Future<void> addWorker(
      {required String name, required Map<String, dynamic> data}) async {
    connectionWithWorkerCollection();
    await workerRef.doc(name).set(data);
  }

  Future<void> updateWorker(
      {required String name, required Map<String, dynamic> data}) async {
    connectionWithWorkerCollection();
    await workerRef.doc(name).update(data);
  }

  Stream<QuerySnapshot> fetchAllWorker() {
    connectionWithWorkerCollection();
    return workerRef.snapshots();
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

  Future<void> updateUsersRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectionWithUsersCollection();

    await userRef.doc(id).update(data);
  }

  Future<void> deleteUsersRecords({required String id}) async {
    connectionWithUsersCollection();

    await userRef.doc(id).delete();
  }
}
