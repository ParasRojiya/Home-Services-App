import 'package:flutter/material.dart';

categoryContainer() {
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
      children: const [
        Expanded(
          flex: 4,
          child: Text("Category Icon/Image"),
        ),
        Divider(
          color: Colors.black,
        ),
        Expanded(child: Text("Category Name")),
      ],
    ),
  );
}
