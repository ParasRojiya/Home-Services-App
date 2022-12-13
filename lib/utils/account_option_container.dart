import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

accountOptionContainer(
    {required String title, required onTap, required IconData icon}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 22),
          const SizedBox(width: 15),
          Text(
            title,
            style: GoogleFonts.poppins(),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 17,
          ),
        ],
      ),
    ),
  );
}
