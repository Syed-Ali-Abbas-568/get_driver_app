import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Toast {
  static void snackBars(String label, Color? color, BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: color,
      dismissDirection: DismissDirection.horizontal,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: const Icon(Icons.cancel))
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150,
        right: MediaQuery.of(context).size.width * 0.055,
        left: MediaQuery.of(context).size.width * 0.055,
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
