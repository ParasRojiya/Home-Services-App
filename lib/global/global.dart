import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upi_india/upi_app.dart';

class Global {
  static Color color = Colors.blue;
  static late bool isAdmin;
  static late bool isWorker;
  static String? imageURL;
  static User? user;
  static Map<String, dynamic>? currentUser;
  static List<dynamic> cart = [];
  static String title = '';
  static List<Map<String, dynamic>> payment = [
    {
      'image': 'assets/images/googlepay.jpg',
      'upiMethod': UpiApp.googlePay,
      'upiName': 'Google Pay',
      'scale': 6.0,
    },
    {
      'image': 'assets/images/paytm.png',
      'upiMethod': UpiApp.paytm,
      'upiName': 'Paytm',
      'scale': 5.0,
    },
    {
      'image': 'assets/images/phonepay.png',
      'upiMethod': UpiApp.phonePe,
      'upiName': 'Phone Pay',
      'scale': 5.0,
    },
    {
      'image': 'assets/images/amazonpay.jpg',
      'upiMethod': UpiApp.amazonPay,
      'upiName': 'Amazon Pay',
      'scale': 1.0,
    },
  ];
}
