import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

elevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    textStyle: GoogleFonts.poppins(
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(vertical: 15),
  );
}
