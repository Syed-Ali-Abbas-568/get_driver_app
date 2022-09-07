// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/screens/home_screen.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/img_button.dart';
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
  bool isLoginError = false;
  String errorMessage = "Something Went Wrong Please Try again";
  bool _passwordVisible = true;

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
                    TextFieldLabel(
                        height: height,
                        bottom: height * 0.01,
                        top: height * 0.02,
                        left: 0,
                        right: 0,
                        label: "Email"),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field required";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      cursorColor: Colors.purple,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: kMessageTextFieldDecoration.copyWith(
                        hintText: 'example@gmail.com',
                      ),
                    ),
                    TextFieldLabel(
                        height: height,
                        top: height * 0.02,
                        bottom: height * 0.01,
                        left: 0,
                        right: 0,
                        label: "Password"),
                    TextFormField(
                      validator: (value) {
                        RegExp regex = RegExp(r"^.{8,}$");
                        if (value!.isEmpty) {
                          return "Field is required";
                        }
                        if (!regex.hasMatch(value)) {
                          return "Password must contain 8 characters minimum";
                        }
                        return null;
                      },
                      cursorColor: Colors.purple,
                      textInputAction: TextInputAction.done,
                      obscureText: _passwordVisible,
                      controller: passController,
                      decoration: kMessageTextFieldDecoration.copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        hintText: '**********',
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
                          child: ImgButton(
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
                          child: ImgButton(
                            height: height,
                            img: "facebook_logo",
                            text: "Facebook",
                            onPressed: googleSignIn,
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
              errorMessage = "Email already in use";
            });
          }
        });
      } else {
        setState(() {
          showSpinner = false;
          sleep(const Duration(seconds: 5));
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

      Fluttertoast.showToast(msg: "Account Created Successfully");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future googleSignIn() async {
    setState(() {
      showSpinner = true;
    });
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;
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

    print(fNameController);
    print(lNameController);
    postDetailsToFireStore();
    setState(() {
      showSpinner = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    Fluttertoast.showToast(msg: credential.signInMethod);
    Fluttertoast.showToast(msg: "SignIn successful");
  }
}
