import 'package:flutter/material.dart';
import 'package:home_services_app/global/global.dart';
import 'package:get/get.dart';
import '../../widgets/category_container.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 220,
          ),
          itemCount: 8,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            return categoryContainer();
            //   Container(
            //   decoration:
            //       BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
            //     BoxShadow(
            //       color: Colors.grey.withOpacity(0.4),
            //       blurRadius: 4,
            //       spreadRadius: 2,
            //       offset: const Offset(0, 0),
            //     ),
            //   ]),
            // );
          },
        ),
      ),
      floatingActionButton: (Global.isAdmin)
          ? FloatingActionButton(
              onPressed: () {
                Get.toNamed('/add_service');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
