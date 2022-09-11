// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class SnackBarWidget {
  static void SnackBars(String label, String img, BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Image.asset(
            img,
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
