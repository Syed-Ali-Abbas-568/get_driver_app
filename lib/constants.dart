import 'package:flutter/material.dart';

class Constants {
  static const kMessageTextFieldDecoration = InputDecoration(
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

  static const searchFieldDecoration = InputDecoration(
    prefixIconColor: Colors.grey,
    prefixIcon: Icon(
      Icons.search,
    ),
    fillColor: Color(0xffEEF3FF),
    filled: true,
    hintText: 'Search Drivers',
    contentPadding: EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffEEF3FF),
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xffEEF3FF),
        width: 2.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
  );

  static const String defaultImage =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfd_zHfi__RrE9HcIukgjGt6HdH7ZFbjERDA&usqp=CAU";
  static const primaryColor = Color(0xFF152C5E);
  static const selectStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
