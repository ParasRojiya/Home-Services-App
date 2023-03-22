import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget workerContainer({
  required String name,
  required int hourlyCharge,
  required String imageURL,
  required String service,
  required int number,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 3),
    height: 120,
    width: Get.width,
    decoration: BoxDecoration(
      color: Colors.indigo.withOpacity(0.07),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        const SizedBox(width: 8),
        Container(
          height: 105,
          width: 115,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(imageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              service,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            Text(
              '+91 $number',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              '4.3 ⭐   |    12 Review',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        )
      ],
    ),
  );
}
