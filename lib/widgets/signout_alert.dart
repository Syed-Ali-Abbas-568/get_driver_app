// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:get_driver_app/screens/login_screen.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';

signOutAlertDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          title: const Text(
            'SignOut',
            style: TextStyle(
              color: Color(0xff152C5E),
            ),
          ),
          content: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "\nAre you sure you want to SignOut?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                      text: "\n*You can SigIn anytime again*",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff152C5E),
                      )),
                ],
              )),
          actions: [
            TextButton(
              onPressed: () async {
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
              child: const Text(
                "SignOut",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xff152C5E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}
