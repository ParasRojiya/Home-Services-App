import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

categoryContainer(
    {required String categoryName,
    required String imageURL,
    required Color color}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 65,
        width: 65,
        padding: const EdgeInsets.all(15),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 6,
            spreadRadius: 3,
          )
        ]),
        child: Image.network(imageURL),
      ),
      const SizedBox(height: 5),
      Container(
        height: 30,
        width: 90,
        alignment: Alignment.center,
        child: Text(
          categoryName,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            height: 1,
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ],
  );
}
