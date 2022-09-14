// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/screens/profile_creation.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _switch();
  }

  _switch() {
    Timer(const Duration(seconds: 3), () async {
      String? id;

      log("Going to Switch");
      bool dataPresent = false;
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        FacebookAuth.instance.getUserData().then((value) {
          id = value['id'].toString();
        });
      } else {
        id = user.uid;
      }
      FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('user_info')
          .snapshots()
          .first
          .then((value) {
        dataPresent = value.docs.isEmpty;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => user == null && id == null
              ? const LoginScreen()
              : dataPresent
                  ? const ProfileCreation()
                  : const NavBar(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height,
            width: width,
            color: const Color(0xff152C5E),
          ),
          Positioned(
            bottom: height * (-0.06),
            left: width * (-0.084),
            child: Image.asset(
              "assets/images/splash_corner_image.png",
              height: height * 0.36,
              width: width * 0.8,
              color: const Color(0xffFBFAFA),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/splashlogo.png",
                height: height * 0.16,
                width: width * 0.35,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              const Text(
                "Get Driver",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xffFBFAFA),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              const Text(
                "Make trips better",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffFBFAFA),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
