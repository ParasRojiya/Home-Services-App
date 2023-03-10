import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({Key? key}) : super(key: key);

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot res =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;
    List data = res['services'];
    String id = res.id;
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: (data.isEmpty)
            ? Center(
                child: Text(
                  "No Services Available",
                  style: GoogleFonts.ubuntu(),
                ),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(data[i]['name']),
                      trailing:IconButton(onPressed: (){

                        Map<String, dynamic> datas = res as Map<String, dynamic>;
                        Deta object = Deta(resp:res, deta: data[i], ids: id);

                        Get.toNamed('/edit_service_page',arguments: object);
                      },icon: const Icon(Icons.edit),color: Colors.orange,),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add_service_page',arguments: res);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class Deta {
  QueryDocumentSnapshot resp;
  Map<String, dynamic> deta;
  String ids;


  Deta({required this.resp, required this.deta, required this.ids});


}