import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../global/global.dart';

class CloudStorageHelper {
  CloudStorageHelper._();
  static final CloudStorageHelper cloudStorageHelper = CloudStorageHelper._();

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static final Reference storageRef = FirebaseStorage.instance.ref();
  final workersRef = storageRef.child("workers");
  final serviceRef = storageRef.child("categories");

  storeWorkerImage({required File image, required String name}) async {
    await workersRef.child(name).putFile(image);
    Global.imageURL = await workersRef.child(name).getDownloadURL();
  }

  deleteWorkerImage({required String name}) async {
    await workersRef.child(name).delete();
  }

  storeServiceImage({required File image, required String name}) async {
    await serviceRef.child(name).putFile(image);
    Global.imageURL = await serviceRef.child(name).getDownloadURL();
  }

  deleteServiceImage({required String name}) async {
    await serviceRef.child(name).delete();
  }
}
