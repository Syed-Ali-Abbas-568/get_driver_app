// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  double height = 0;
  double width = 0;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool showSpinner = false;
//TODO: Global variables should be priavte. Still not Following :(

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: const Color(0xff152C5E),
      ),
      body: Padding(
        padding: EdgeInsets.all(height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.03),
              child: const Text(
                "Enter your email to reset reset password",
                style: TextStyle(color: Color(0xff152C5E), fontSize: 28),
              ),
            ),
            TextFieldLabel(
                height: height,
                top: 0,
                right: 0,
                left: 0,
                bottom: height * 0.01,
                label: "Email"),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                cursorColor: Colors.purple,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: kMessageTextFieldDecoration.copyWith(
                  hintText: 'example@gmail.com',
                ),
              ),
            ),
            Container(
              width: width,
              padding: EdgeInsets.only(top: height * 0.055),
              child: Material(
                color: const Color(0xff152C5E),
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    resetPassword(emailController.text);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: showSpinner
                      ? const CircularProgressIndicator(
                          color: Color(0xffFBFAFA),
                        )
                      : const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword(String email) async {
    if (_formKey.currentState!.validate()) {
      try {
        var result =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        // print(result);
        if (result.isEmpty) {
          SnackBarWidget.SnackBars(
              "Account not found", "assets/images/errorImg.png", context: context);
          setState(() {
            showSpinner = false;
          });
        } else {
          FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          SnackBarWidget.SnackBars(
              "Email Sent", "assets/images/successImg.png",  context: context);
          setState(() {
            showSpinner = false;
          });
        }
      } catch (e) {
        SnackBarWidget.SnackBars(
            e.toString(), "assets/images/successImg.png", context: context);

        setState(() {
          showSpinner = false;
        });
      }
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }
}
