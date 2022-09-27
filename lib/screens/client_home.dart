import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'login_screen.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Client Home Screen"),
            ElevatedButton(
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
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
