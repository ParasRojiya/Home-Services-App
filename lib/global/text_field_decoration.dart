import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'global.dart';

textFieldDecoration({required IconData icon, required String name}) {
  return InputDecoration(
    fillColor: Global.color.withOpacity(0.03),
    filled: true,
    contentPadding: EdgeInsets.all(5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    hintStyle: GoogleFonts.habibi(
      fontWeight: FontWeight.w300,
    ),
    prefixIcon: Icon(icon),
    label: Text(
      name,
      style: GoogleFonts.habibi(
        fontWeight: FontWeight.w500,
      ),
    ),
    hintText: "Enter Your $name here...",
  );
}
