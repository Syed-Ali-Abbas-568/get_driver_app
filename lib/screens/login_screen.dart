// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unnecessary_null_comparison
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/auth_providers.dart';
import 'package:get_driver_app/screens/forgot_password.dart';
import 'package:get_driver_app/screens/create_profile.dart';
import 'package:get_driver_app/screens/register_screen.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/email_password_textfields.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double height = 0;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: height * 0.085,
                  left: height * 0.0225,
                  // bottom: height * 0.113,
                  right: height * 0.0225),
              child: const Text(
                "Sign in",
                style: TextStyle(
                  color: Color(0xff152C5E),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: height * 0.0213, right: height * 0.0213),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 48.0,
                      ),
                      EmailPasswordTextField(
                        emailController: emailController,
                        passController: passController,
                        height: height,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword()));
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff152C5E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.055),
                        child: Material(
                          color: const Color(0xff152C5E),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              if (_formKey.currentState!.validate()) {
                                await context
                                    .read<AuthProvider>()
                                    .signInWithEmailPassword(
                                      emailController.text,
                                      passController.text,
                                    );

                                // final authProvider = ;

                                if (context.read<AuthProvider>().hasError) {
                                  SnackBarWidget.SnackBars(
                                    context.read<AuthProvider>().errorMsg,
                                    "assets/images/errorImg.png",
                                    context: context,
                                  );
                                  return;
                                }

                                SnackBarWidget.SnackBars(
                                  "Sign in successful",
                                  "assets/images/successImg.png",
                                  context: context,
                                );

                                String? dataPresent;
                                User? user = FirebaseAuthService().firebaseUser;

                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(user!.uid)
                                    .snapshots()
                                    .first
                                    .then((value) {
                                  dataPresent = value.get('CNIC').toString();
                                  log(dataPresent.toString());
                                  // log(value.docs.isEmpty.toString());
                                });

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => user == null
                                        ? const LoginScreen()
                                        : dataPresent == null
                                            ? const ProfileCreation()
                                            : const NavBar(),
                                  ),
                                );
                              }
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: context.watch<AuthProvider>().isLoading
                                ? const CircularProgressIndicator(
                                    color: Color(0xffFBFAFA),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Color(0xff8893AC),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            style: const ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationScreen()));
                            },
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Color(0xff152C5E), fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      DividerWidget(width: width, height: height),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.032),
                              child: context.watch<AuthProvider>().isLoading
                                  ? const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        color: Color(0xff152C5E),
                                      ),
                                    )
                                  : ImgButton(
                                      height: height,
                                      img: "google_logo",
                                      text: "Google",
                                      onPressed: () async {
                                        AuthProvider authProvider =
                                            AuthProvider();
                                        if (authProvider.hasError) {
                                          SnackBarWidget.SnackBars(
                                              authProvider.errorMsg,
                                              "assets/images/errorImg.png",
                                              context: context);
                                          return;
                                        }
                                        SnackBarWidget.SnackBars(
                                            "Sign in successful",
                                            "assets/images/successImg.png",
                                            context: context);
                                        UserModel? userModel = await context
                                            .read<AuthProvider>()
                                            .GoogleSignUpFunc();
                                        if (userModel != null) {
                                          Future.delayed(
                                              const Duration(seconds: 3));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FirebaseAuth
                                                          .instance
                                                          .currentUser ==
                                                      null
                                                  ? const LoginScreen()
                                                  : userModel.CNIC==null
                                                      ? const ProfileCreation()
                                                      : const NavBar(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: width * 0.032),
                              child: context.watch<AuthProvider>().isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(0xff152C5E),
                                    )
                                  : ImgButton(
                                      height: height,
                                      img: "facebook_logo",
                                      text: "Facebook",
                                      onPressed: () async {
                                        AuthProvider authProvider =
                                            AuthProvider();
                                        if (authProvider.hasError) {
                                          SnackBarWidget.SnackBars(
                                              authProvider.errorMsg,
                                              "assets/images/errorImg.png",
                                              context: context);
                                          return;
                                        }
                                        UserModel? userModel = await context
                                            .read<AuthProvider>()
                                            .FacebookSignUp();
                                        if (userModel == null ||
                                            userModel.CNIC == null) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileCreation(),
                                            ),
                                          );
                                          SnackBarWidget.SnackBars(
                                              "Sign in successful",
                                              "assets/images/successImg.png",
                                              context: context);
                                        } else {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const NavBar(),
                                            ),
                                          );
                                          SnackBarWidget.SnackBars(
                                              "Sign in successful",
                                              "assets/images/successImg.png",
                                              context: context);
                                        }
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _facebookSignIn() async {}
}
