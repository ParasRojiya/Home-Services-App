import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'global.dart';

textFieldDecoration({required IconData icon, required String name}) {
  return InputDecoration(
    fillColor: Global.color.withOpacity(0.03),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
    ),
    hintStyle: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: Icon(icon),
    label: Text(
      name,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
      ),
    ),
    hintText: "Enter Your $name here...",
  );
}
