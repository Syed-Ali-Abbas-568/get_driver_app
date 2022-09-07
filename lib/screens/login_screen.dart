// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/screens/home_screen.dart';
import 'package:get_driver_app/screens/register_screen.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';
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
  bool _passwordVisible = true;
  bool isLoginError = false;
  double height = 0;
  double width = 0;

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
                        child: const Text(
                          "Please check your email or password",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      TextFieldLabel(
                          height: height,
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: height * 0.01,
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff152C5E),
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
                            child: showSpinner
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
                            child: showSpinner
                                ? const CircularProgressIndicator(
                                    color: Color(0xff152C5E),
                                  )
                                : ImgButton(
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
          Fluttertoast.showToast(msg: "Login Successful");
        });
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()))
            .catchError((e) {
          Fluttertoast.showToast(msg: e);
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
          isLoginError = true;
        });
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      setState(() {
        isLoginError = true;
        showSpinner = false;
      });
    }
  }

  Future googleSignIn() async {
    final googleUser = await _googleSignIn.signIn();
    setState(() {
      showSpinner = true;
    });
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    setState(() {
      showSpinner = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
