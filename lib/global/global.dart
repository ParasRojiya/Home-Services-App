import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Global {
  static Color color = Colors.blue;
  static late bool isAdmin;
  static String? imageURL;
  static User? user;
  static Map<String, dynamic>? currentUser;
  static List<dynamic> cart = [];
}
