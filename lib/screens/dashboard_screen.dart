import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                SnackBarWidget.SnackBars("Signout successful",
                    "assets/images/successImg.png", context);
              },
              child: const Text("Logout"))),
    );
  }
}
