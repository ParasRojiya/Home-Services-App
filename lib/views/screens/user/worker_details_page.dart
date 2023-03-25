import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerDetailsPage extends StatelessWidget {
  const WorkerDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic res = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(res['name']),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}
