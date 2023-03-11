import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services_app/global/button_syle.dart';
import 'package:home_services_app/views/screens/admin/all_services_page.dart';
import 'package:time_range/time_range.dart';

class BookService extends StatefulWidget {
  const BookService({Key? key}) : super(key: key);

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  @override
  Widget build(BuildContext context) {
    Argument res = ModalRoute.of(context)!.settings.arguments as Argument;
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Service"),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(res.currentData['imageURL']),
                  radius: 65,
                ),
                const SizedBox(height: 12),
                Text(res.currentData['name']),
                const SizedBox(height: 12),
                Text("${res.currentData['price']} Rs."),
                const SizedBox(height: 12),
                Text(res.currentData['desc']),
                const SizedBox(height: 12),
                Text(res.currentData['duration']),
              ],
            ),
            Column(
              children: [
                TimeRange(
                    timeBlock: 0,
                    onRangeCompleted: (range) {},
                    firstTime: TimeOfDay(hour: 8, minute: 00),
                    lastTime: TimeOfDay(
                      hour: 20,
                      minute: 00,
                    )),
                Container(
                  width: Get.width * 0.90,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: elevatedButtonStyle(),
                    child: const Text("Book Service"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
