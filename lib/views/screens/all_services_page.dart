import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({Key? key}) : super(key: key);

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> data =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(

                title: Text(data[i]['name']),
              ),
            );
          },
        ),
      ),
    );
  }
}
