// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // final _auth = FirebaseAuth.instance;
  final lNameController = TextEditingController();
  final passController = TextEditingController();
  final fNameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // bool showSpinner = false;
  bool isLoginError = false;
  String errorMessage = "Something Went Wrong Please Try again";
  bool _passwordVisible = true;
  // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['Email']);
  // GoogleSignInAccount? _user;

  // GoogleSignInAccount? get user => _user;
  double height=0;
  double width=0;
  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
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
                      const SizedBox(
                        height: 48.0,
                      ),
                      // Visibility(
                      //   visible: isLoginError,
                      //   child: const Text(
                      //     "Please check your email or password",
                      //     style: TextStyle(
                      //       color: Colors.red,
                      //       fontSize: 15,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.01),
                        child: const Text(
                          "First Name",
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
                          if (!RegExp(r"^.{8,}$")
                              .hasMatch(value)) {
                            return "Enter a valid Name";
                          }
                          return null;
                        },
                        cursorColor: Colors.purple,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: fNameController,
                        decoration: kMessageTextFieldDecoration.copyWith(

                          hintText: 'John',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.01,top: height*0.02),
                        child: const Text(
                          "Last Name",
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
                          if (!RegExp(r"^.{8,}$")
                              .hasMatch(value)) {
                            return "Enter a valid Last name";
                          }
                          return null;
                        },
                        cursorColor: Colors.purple,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: lNameController,
                        decoration: kMessageTextFieldDecoration.copyWith(

                          hintText: 'Doe',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.01,top: height*0.02),
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
                                // showSpinner = true;
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
                                      builder: (context) =>
                                      const LoginScreen()));
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
            ],
          ),
        ),
      ),
    );
  }


  void SignUp(String email, String password) async {
    // try {
    //   if (_formKey.currentState!.validate()) {
    //     setState(() {
    //       showSpinner = true;
    //     });
    //     sleep(const Duration(seconds: 5));
    //     await _auth
    //         .createUserWithEmailAndPassword(email: email, password: password)
    //         .then((value) {
    //       postDetailsToFireStore();
    //     }).catchError((e) {
    //       if (e.toString() ==
    //           "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
    //         setState(() {
    //           errorMessage = "Email already in use";
    //         });
    //       }
    //       setState(() {
    //         showSpinner = false;
    //       });
    //       setState(() {
    //         isLoginError = true;
    //       });
    //     });
    //   } else {
    //     setState(() {
    //       showSpinner = false;
    //     });
    //     sleep(const Duration(seconds: 5));
    //     setState(() {
    //       isLoginError = true;
    //     });
    //   }
    // } catch (e) {
    //   setState(() {
    //     showSpinner = false;
    //   });
    //   setState(() {
    //     isLoginError = true;
    //   });
    // }
  }

// postDetailsToFireStore() async {
//   try {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;
//     CredentialUserModel credentialUserModel = CredentialUserModel();
//     credentialUserModel.userName = name_Controller.text;
//     credentialUserModel.email = user!.email;
//     credentialUserModel.id = user.uid;
//     await firebaseFirestore
//         .collection('Users')
//         .doc(user.uid)
//         .set(credentialUserModel.toMap());
//
//     Fluttertoast.showToast(msg: "Account Created Successfully");
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context) => WelcomeUserScreen()));
//   } catch (e) {
//     Fluttertoast.showToast(msg: e.toString());
//   }
// }
//
// Future googleSignIn() async {
//   setState(() {
//     showSpinner = true;
//   });
//   final googleUser = await _googleSignIn.signIn();
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
//     name_Controller.text = _user!.displayName.toString();
//   });
//
//   print(name_Controller.text);
//   postDetailsToFireStore();
//   setState(() {
//     showSpinner = false;
//   });
//   Navigator.pushReplacement(
//       context, MaterialPageRoute(builder: (context) => WelcomeUserScreen()));
//   Fluttertoast.showToast(msg: credential.signInMethod);
//   Fluttertoast.showToast(msg: "SignIn successful");
// }
}