// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/screens/profile_screen.dart';

import 'package:get_driver_app/widgets/clientHome_stream.dart';
import 'package:get_driver_app/widgets/client_screen_banner.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'login_screen.dart';

class ClientHome extends StatefulWidget {
  ClientHome({super.key, this.name = "John"});
  String name;
  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff152C5E),
        elevation: 8,
        title: const Center(child: Text("Home")),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset(
              "assets/images/profile.png",
              width: width * 0.08,
              height: height * 0.036,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FacebookAuth.instance.logOut();
              FirebaseAuth.instance.signOut().then((value) {
                SnackBarWidget.SnackBars(
                  "Signout successful",
                  "assets/images/successImg.png",
                  context: context,
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClientScreenBanner(width: width, height: height, name: widget.name),
            SizedBox(
              height: 559,
              child: ClientHomeStream(height: height, width: width),
            ),
          ],
        ),
      ),
    );
  }
}
