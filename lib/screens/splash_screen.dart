import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

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
    Timer(const Duration(seconds: 3), () {
      log("Going to Switch");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              // user == null?
              const LoginScreen()
                  // : dataPresent
                  // ? OnBoardingScreen()
                  // : ShifterScreen()
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: height,
              width: width,
              color: const Color(0xff152C5E),
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
                  height: height*0.02,
                ),
                const Text("Get Driver",style: TextStyle(
                  fontSize: 28,
                  color: Color(0xffFBFAFA),
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(
                  height: height*0.015,
                ),
                const Text("Make trips better",style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffFBFAFA),
                  fontWeight: FontWeight.w400,
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
