// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/auth_providers.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/screens/create_profile.dart';
import 'package:get_driver_app/screens/forgot_password.dart';
import 'package:get_driver_app/screens/register_screen.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/email_password_textfields.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _height = 0;
  double _width = 0;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: _height * 0.085,
                left: _height * 0.0225,
                right: _height * 0.0225,
              ),
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
                left: _height * 0.0213,
                right: _height * 0.0213,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 48.0),
                      EmailPasswordTextField(
                        emailController: _emailController,
                        passController: _passController,
                        height: _height,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                ),
                              );
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
                        padding: EdgeInsets.only(top: _height * 0.055),
                        child: Material(
                          color: const Color(0xff152C5E),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              if (_formKey.currentState!.validate()) {
                                await context
                                    .read<AuthProvider>()
                                    .signInWithEmailPassword(
                                      _emailController.text,
                                      _passController.text,
                                    );

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

                                UserModel? userModel = await context
                                    .read<FirestoreProvider>()
                                    .getUserData();

                                if (userModel == null) return;

                                dataPresent = userModel.cnic.toString();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => user == null
                                        ? const LoginScreen()
                                        : dataPresent == null
                                            ? CreateProfile(userModel.firstName.toString(),userModel.lastName.toString(),userModel.email.toString(),)
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
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
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
                                      const RegistrationScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                color: Color(0xff152C5E),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      DividerWidget(
                        width: _width,
                        height: _height,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: _width * 0.032),
                              child: ImgButton(
                                height: _height,
                                img: "google_logo",
                                text: "Google",
                                onPressed: () async {
                                  AuthProvider authProvider = AuthProvider();
                                  if (authProvider.hasError) {
                                    SnackBarWidget.SnackBars(
                                      authProvider.errorMsg,
                                      "assets/images/errorImg.png",
                                      context: context,
                                    );
                                    return;
                                  }

                                  UserModel? userModel = await context
                                      .read<AuthProvider>()
                                      .googleSignUpFunc();
                                  if (userModel != null) {
                                    Future.delayed(const Duration(seconds: 3));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FirebaseAuth.instance.currentUser ==
                                                    null
                                                ? const LoginScreen()
                                                : userModel.cnic == null
                                                    ? CreateProfile(userModel.firstName.toString(),userModel.lastName.toString(),userModel.email.toString(),)
                                                    : const NavBar(),
                                      ),
                                    );
                                    SnackBarWidget.SnackBars(
                                      "Sign in successful",
                                      "assets/images/successImg.png",
                                      context: context,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: _width * 0.04),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: _width * 0.032),
                              child: ImgButton(
                                height: _height,
                                img: "facebook_logo",
                                text: "Facebook",
                                onPressed: () async {
                                  AuthProvider authProvider = AuthProvider();
                                  if (authProvider.hasError) {
                                    SnackBarWidget.SnackBars(
                                        authProvider.errorMsg,
                                        "assets/images/errorImg.png",
                                        context: context);
                                    return;
                                  }
                                  UserModel? userModel = await context
                                      .read<AuthProvider>()
                                      .facebookSignUp();
                                  if (userModel == null ||
                                      userModel.cnic == null) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateProfile(userModel!.firstName.toString(),userModel.lastName.toString(),userModel.email.toString(),),
                                      ),
                                    );
                                    SnackBarWidget.SnackBars(
                                        "Sign in successful",
                                        "assets/images/successImg.png",
                                        context: context);
                                  } else {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const NavBar(),
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
}
