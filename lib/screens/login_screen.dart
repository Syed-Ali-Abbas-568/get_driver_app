// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/screens/forgot_password.dart';
import 'package:get_driver_app/screens/home_screen.dart';
import 'package:get_driver_app/screens/register_screen.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/email_password_textfields.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool showFacebookSpinner = false;
  bool showGoogleSpinner = false;
  bool isLoginError = false;
  double height = 0;
  double width = 0;
  String errorMessage = "";

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['Email']);
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

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
                      Visibility(
                        visible: isLoginError,
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
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
                            onPressed: () {
                              setState(() {
                                showSpinner = true;
                              });
                              singIn(emailController.text, passController.text);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: showSpinner
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
                          Container(
                            margin: EdgeInsets.only(left: width * 0.032),
                            child: showGoogleSpinner
                                ? const CircularProgressIndicator(
                                    color: Color(0xff152C5E),
                                  )
                                : ImgButton(
                                    height: height,
                                    img: "google_logo",
                                    text: "Google",
                                    onPressed: googleSignIn,
                                  ),
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: width * 0.032),
                            child: showFacebookSpinner
                                ? const CircularProgressIndicator(
                                    color: Color(0xff152C5E),
                                  )
                                : ImgButton(
                                    height: height,
                                    img: "facebook_logo",
                                    text: "Facebook",
                                    onPressed: facebookLogin,
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

  void singIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) {
          setState(() {
            isLoginError = false;
          });
          SnackBarWidget.SnackBars(
              "Sign in Successful", "assets/images/successImg.png", context);
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } catch (e) {
        setState(() {
          showSpinner = false;
          isLoginError = true;
          if (e.toString() ==
              "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
            SnackBarWidget.SnackBars(
                "Incorrect Password", "assets/images/errorImg.png", context);
          } else if (e.toString() ==
              "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
            SnackBarWidget.SnackBars(
                "Account not found", "assets/images/errorImg.png", context);
          } else {
            SnackBarWidget.SnackBars(
                "Something went wrong", "assets/images/errorImg.png", context);
          }
        });
      }
    } else {
      setState(() {
        // isLoginError = true;
        showSpinner = false;
      });
    }
  }

  // ignore: non_constant_identifier_names

  void facebookLogin() async {
    setState(() {
      showFacebookSpinner = true;
    });
    try {
      final result = await FacebookAuth.instance.login();
      print(result);
      if (result.status == LoginStatus.success) {
        // final requestData = await FacebookAuth.instance.getUserData();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
        SnackBarWidget.SnackBars(
            "Sing in successful", "assets/images/successImg.png", context);
        setState(() {
          showFacebookSpinner = false;
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        setState(() {
          showFacebookSpinner = false;
        });
        SnackBarWidget.SnackBars("Something went wrong try again",
            "assets/images/errorImg.png", context);
      }
    } catch (e) {
      setState(() {
        showFacebookSpinner = false;
      });
    }
  }

  Future googleSignIn() async {
    setState(() {
      showGoogleSpinner = true;
    });
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      setState(() {
        showGoogleSpinner = false;
      });
      SnackBarWidget.SnackBars("Something went wrong try again",
          "assets/images/errorImg.png", context);
      return;
    }
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    setState(() {
      showGoogleSpinner = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
