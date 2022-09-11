// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:get_driver_app/providers/auth_providers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:get_driver_app/screens/forgot_password.dart';
import 'package:get_driver_app/screens/home_screen.dart';
import 'package:get_driver_app/screens/register_screen.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/email_password_textfields.dart';
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
                                final userCred = await context
                                    .read<AuthProviders>()
                                    .SignInWithEmailPass(
                                      emailController.text,
                                      passController.text,
                                      context,
                                    );
                                if (userCred != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                }
                              }
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: context.watch<AuthProviders>().isLoading
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
                            child:
                                context.watch<AuthProviders>().isGoogleLoading
                                    ? const CircularProgressIndicator(
                                        color: Color(0xff152C5E),
                                      )
                                    : ImgButton(
                                        height: height,
                                        img: "google_logo",
                                        text: "Google",
                                        onPressed: () async {
                                          GoogleSignInAccount? account =
                                              await context
                                                  .read<AuthProviders>()
                                                  .GoogleSignInFunc(context);
                                          if (account != null) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                          ),
                          SizedBox(
                            width: width * 0.04,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: width * 0.032),
                            child: context
                                    .watch<AuthProviders>()
                                    .isFacebookLoading
                                ? const CircularProgressIndicator(
                                    color: Color(0xff152C5E),
                                  )
                                : ImgButton(
                                    height: height,
                                    img: "facebook_logo",
                                    text: "Facebook",
                                    onPressed: () async {
                                      Map<String, dynamic>? data = await context
                                          .read<AuthProviders>()
                                          .FacebookSignIn(context);
                                      if (data != null) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
                                        );
                                      }
                                    },
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
