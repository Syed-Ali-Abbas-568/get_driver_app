import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/screens/login_screen.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                FacebookAuth.instance.logOut();
                FirebaseAuth.instance.signOut().then((value) {
                  SnackBarWidget.SnackBars(
                      "Signout successful", "assets/images/successImg.png",
                      context: context);
//TODO: Trailing commas not use :(

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                });
              },
              child: const Text("Logout"))),
    );
  }
}
