// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/screens/home_screen.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/email_password_textfields.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final lNameController = TextEditingController();
  final passController = TextEditingController();
  final fNameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  bool showFacebookSpinner = false;
  bool showGoogleSpinner = false;
  bool isLoginError = false;
  String errorMessage = "Something Went Wrong Please Try again";

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['Email']);
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;
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
                  right: height * 0.0225),
              child: const Text(
                "Sign up",
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: height * 0.06),
                    TextFieldLabel(
                      height: height,
                      label: "First Name",
                      top: 0,
                      bottom: height * 0.01,
                      left: 0,
                      right: 0,
                    ),
                    TextFieldWidget(
                      fNameController: fNameController,
                      errorText: "Enter a valid first name",
                      hintText: "John",
                      inputType: TextInputType.name,
                    ),
                    TextFieldLabel(
                        height: height,
                        bottom: height * 0.01,
                        top: height * 0.02,
                        left: 0,
                        right: 0,
                        label: "Last Name"),
                    TextFieldWidget(
                      fNameController: lNameController,
                      errorText: "Enter a valid last name",
                      hintText: "John",
                      inputType: TextInputType.name,
                    ),
                    EmailPasswordTextField(
                      emailController: emailController,
                      passController: passController,
                      height: height,
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
                            SignUp(emailController.text, passController.text);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: showSpinner
                              ? const CircularProgressIndicator(
                                  color: Color(0xffFBFAFA),
                                )
                              : const Text(
                                  'Sign up',
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
                          'Already have an account',
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
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            "Sign in",
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
          ],
        ),
      ),
    );
  }


  void SignUp(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          postDetailsToFireStore();
        }).catchError((e) {
          if (e.toString() ==
              "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
            setState(() {
              showSpinner = false;
              isLoginError = true;
            });
            SnackBarWidget.SnackBars(
                "Email already in use", "assets/images/errorImg.png", context);
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          isLoginError = true;
        });
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
        isLoginError = true;
      });
    }
  }

  postDetailsToFireStore() async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();
      userModel.firstName = fNameController.text;
      userModel.lastName = lNameController.text;
      userModel.email = user!.email;
      userModel.id = user.uid;
      await firebaseFirestore
          .collection('Users')
          .doc(user.uid)
          .set(userModel.toMap());

      SnackBarWidget.SnackBars("Account created successfully",
          "assets/images/successImg.png", context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      SnackBarWidget.SnackBars(
          e.toString(), "assets/images/errorImg.png", context);
    }
  }

  void facebookLogin() async {
    setState(() {
      showFacebookSpinner = true;
    });
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // final requestData = await FacebookAuth.instance.getUserData();
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
      final name = _user!.displayName?.split(" ");
      fNameController.text = name![0];
      lNameController.text = name[1];
    });
    postDetailsToFireStore();
    setState(() {
      showGoogleSpinner = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    SnackBarWidget.SnackBars(
        "Sign in Successful", "assets/images/successImg.png", context);
  }
}
