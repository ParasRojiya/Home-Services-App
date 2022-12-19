import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
        child: Card(
          elevation: 5,
          shadowColor: Colors.grey,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                    res['imageURL'],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  res['name'],
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${res['experience']} Exp.",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "⭐⭐⭐⭐⭐",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "₹${res['price']}/hr ",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Book Now")),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
