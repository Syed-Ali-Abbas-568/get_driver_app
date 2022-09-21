import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:get_driver_app/screens/login_screen.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("This is Home Screen"),
          ElevatedButton(
            onPressed: () {
              FacebookAuth.instance.logOut();
              FirebaseAuth.instance.signOut();
              SnackBarWidget.SnackBars(
                "SignOut Successful",
                "assets/images/successImg.png",
                context: context,
              );

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text(
              "Press to go back and signout",
            ),
          ),
        ],
      ),
    );
  }
}
