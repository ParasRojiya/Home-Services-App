import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_app/helper/cloud_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global/global.dart';

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
                      trailing:(Global.isAdmin)?IconButton(onPressed: (){

                        Argument args = Argument(i:i , fullData: res,ids: id, currentData: data[i]);

                        Get.toNamed('/edit_service_page',arguments: args);
                      },icon: const Icon(Icons.edit),color: Colors.orange,):IconButton(onPressed: (){
                        Argument args = Argument(i:i , fullData: res,ids: id, currentData: data[i]);
                        Get.toNamed('/book_service',arguments: args);
                      }, icon: const Icon(Icons.arrow_forward_ios)),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton:(Global.isAdmin)? FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add_service_page',arguments: res);
        },
        child: const Icon(Icons.add),
      ):null,
    );
  }
}


class Argument {
  int i;
  QueryDocumentSnapshot fullData;
  Map<String, dynamic> currentData;
  String ids;

  Argument({required this.i ,required this.fullData, required this.currentData, required this.ids});

}