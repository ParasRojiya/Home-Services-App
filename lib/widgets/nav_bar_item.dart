import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

bottomNavBarItem({required Icon icon, required String title}) {
  return PersistentBottomNavBarItem(
    icon: icon,
    title: title,
    textStyle: GoogleFonts.poppins(),
    activeColorPrimary: Colors.teal,
    inactiveColorPrimary: Colors.blue,
  );
}
