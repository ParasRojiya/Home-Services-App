import 'package:cloud_firestore/cloud_firestore.dart';

import '../global/global.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();

  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference userRef;
  late CollectionReference categoryRef;
  late CollectionReference workerRef;
  late CollectionReference bookingsRef;
  late CollectionReference chatRef;
  late CollectionReference shoppingRef;

  //CATEGORIES COLLECTION HELPER
  connectionWithCategoryCollection() {
    categoryRef = firebaseFirestore.collection('categories');
  }

  // Future<void> addService(
  //     {required String name, required Map<String, dynamic> data}) async {
  //   connectionWithCategoryCollection();
  //   await categoryRef.doc(name).set(data);
  // }

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

  //add to cart
  addToCart(Map<String, dynamic> item) {
    connectionWithCategoryCollection();
    connectionWithUsersCollection();

    userRef.doc(Global.currentUser!["email"]).update(item);
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

  Future<void> deleteWorker({required String name}) async {
    connectionWithWorkerCollection();
    await workerRef.doc(name).delete();
  }

  Stream<QuerySnapshot> fetchAllWorker() {
    connectionWithWorkerCollection();
    return workerRef.snapshots();
  }

  //BOOKINGS COLLECTION HELPER

  connectionWithBookingsCollection() {
    bookingsRef = firebaseFirestore.collection('bookings');
  }

  Future<void> addServiceInBookingCollection(
      {required Map<String, dynamic> data}) async {
    connectionWithBookingsCollection();
    await bookingsRef.add(data);
  }

  Future<void> deleteBooking({required String id}) async {
    connectionWithBookingsCollection();
    await bookingsRef.doc(id).delete();
  }

  Stream<QuerySnapshot> fetchAllBookings() {
    connectionWithBookingsCollection();
    return bookingsRef.snapshots();
  }

  //USERS COLLECTION HELPER
  connectionWithUsersCollection() {
    userRef = firebaseFirestore.collection('users');
  }

  Future<void> insertDataInUsersCollection(
      {required Map<String, dynamic> data}) async {
    connectionWithUsersCollection();
    await userRef.doc(data["email"]).set(data);
    //bookingsRef.doc(data["email"]).set({"bookings":[]});
  }

  // Stream<QuerySnapshot> fetchCart({required String id})  {
  //   connectionWithUsersCollection();
  //
  //  // return userRef.doc(id).snapshots();
  // }

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

  //CHAT COLLECTION
  connectionWithChatCollection() async {
    chatRef = firebaseFirestore.collection('chats');
  }

  selectChatRecords() {
    connectionWithChatCollection();
    return chatRef.snapshots();
  }

  insertChatRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectionWithChatCollection();
    await chatRef.doc(id).set(data);
  }

  //SHOPPING COLLECTION
  connectionWithShoppingCollection() {
    shoppingRef = firebaseFirestore.collection('shopping');
  }

  fetchShoppingRecords() {
    connectionWithShoppingCollection();
    return shoppingRef.snapshots();
  }
}
