import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../global/global.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({Key? key}) : super(key: key);

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot res =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;
    return Scaffold(
      appBar: AppBar(
        title: (Global.isAdmin)
            ? Text("Edit ${res.id} Service".capitalize!)
            : Text("Book ${res.id} Service".capitalize!),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 1,
                spreadRadius: 4,
                color: Colors.grey.withOpacity(0.4),
              ),
            ]),
      ),
    );
  }
}
