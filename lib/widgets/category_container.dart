import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

categoryContainer({required String categoryName, required String imageURL}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 0),
        ),
      ],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(
                    imageURL,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        // const Divider(
        //   color: Colors.black,
        // ),
        const SizedBox(height: 6),
        Expanded(
            child: Text(
          categoryName.toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        )),
      ],
    ),
  );
}
