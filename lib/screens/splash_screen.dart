// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/screens/client_createProfile.dart';
import 'package:get_driver_app/screens/client_home.dart';
import 'package:get_driver_app/screens/driver_create_profile.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:get_driver_app/screens/login_screen.dart';

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
      FirebaseAuthService firebaseAuthService = FirebaseAuthService();
      UserModel? userModel =
          await context.read<FirestoreProvider>().getUserData();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => firebaseAuthService.firebaseUser != null
              ? userModel?.cnic == null
                  ? userModel?.userType == "client"
                      ? const ClientCreateProfile()
                      : const DriverCreateProfile()
                  : userModel?.userType == "client"
                      ? ClientHome(
                          name:
                              "${userModel?.firstName} ${userModel?.lastName}")
                      : const NavBar()
              : const LoginScreen(),
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
