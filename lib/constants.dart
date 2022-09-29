import 'package:flutter/material.dart';

const kMessageTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 20.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff152C5E),
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
);

Color primaryColor = const Color(0xFF152C5E);
const selectStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

//Positioned(
//                       left: 16,
//                       top: 409,
//                       width: 113,
//                       height: 24,
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFE4FAE6),
//                           shape: BoxShape.rectangle,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(5),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             const Icon(
//                               Icons.circle,
//                               color: Color(0xFF7AE582),
//                               size: 17,
//                             ),
//                             Text(
//                               "Available for hire",
//                               style: GoogleFonts.manrope(
//                                 fontStyle: FontStyle.normal,
//                                 color: const Color(0xFF152C5E),
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
