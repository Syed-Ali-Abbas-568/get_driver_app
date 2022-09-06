// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/screens/register_screen.dart';
import 'package:get_driver_app/widgets/img_button.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool _passwordVisible = true;
  bool isLoginError = false;
  double height=0;
  double width=0;
  // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['Email']);
  // GoogleSignInAccount? _user;
  // GoogleSignInAccount? get user => _user;
  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: height * 0.085,
                  left: height * 0.0225,
                  bottom: height * 0.113,
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
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.01),
                        child: const Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.02, bottom: height * 0.01),
                        child: const Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
                              // singIn(emailController.text, passController.text);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: const Text(
                              'Log In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width * 0.032),
                            child: ImgButton(
                              height: height,
                              img: "google_logo",
                              text: "Google",
                            ),
                          ),
                          SizedBox(width: width*0.04,),
                          Container(
                            margin: EdgeInsets.only(right: width*0.032),
                            child: ImgButton(
                              height: height,
                              img: "facebook_logo",
                              text: "Facebook",
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

// void singIn(String email, String password) async {
//   if (_formKey.currentState!.validate()) {
//     try {
//       await _auth
//           .signInWithEmailAndPassword(email: email, password: password)
//           .then((uid) {
//         Fluttertoast.showToast(msg: "Login Successful");
//       });
//       setState(() {
//         isLoginError = false;
//       });
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) => WelcomeUserScreen()))
//           .catchError((e) {
//         Fluttertoast.showToast(msg: e);
//       });
//     } catch (e) {
//       sleep(const Duration(seconds: 5));
//       showSpinner = false;
//       setState(() {
//         isLoginError = true;
//       });
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   } else {
//     setState(() {
//       isLoginError = true;
//     });
//     showSpinner = false;
//   }
// }

// Future googleSignIn() async {
//   final googleUser = await _googleSignIn.signIn();
//   setState(() {
//     showSpinner = true;
//   });
//   if (googleUser == null) return;
//   _user = googleUser;
//
//   final googleAuth = await googleUser.authentication;
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//
//   await FirebaseAuth.instance.signInWithCredential(credential);
//   setState(() {
//     showSpinner = false;
//   });
//   Navigator.pushReplacement(
//       context, MaterialPageRoute(builder: (context) => WelcomeUserScreen()));
// }
}
