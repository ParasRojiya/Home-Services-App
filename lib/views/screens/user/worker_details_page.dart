import 'package:flutter/cupertino.dart';
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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        title: Text(
          "Worker",
          style: GoogleFonts.habibi(),
        ),
        elevation: 5,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            height: 220,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(res['imageURL']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    res['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      height: 27,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.indigo.shade50,
                      ),
                      child: Text(res['category']),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Gender : ${res['gender']}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  'Mobile No. : +91 ${res['number']}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email : ${res['email']}',
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 15),
                Text(
                  "Description : ",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "                              Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy, text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
