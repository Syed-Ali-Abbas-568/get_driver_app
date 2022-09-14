// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:get_driver_app/providers/auth_providers.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/email_password_textfields.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final lNameController = TextEditingController();
  final passController = TextEditingController();
  final fNameController = TextEditingController();
  final emailController = TextEditingController();
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
                      controller: fNameController,
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
                      controller: lNameController,
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState!.validate()) {
                                final userCred = await context
                                    .read<AuthProviders>()
                                    .SignUpWithEmailPass(
                                      fNameController.text,
                                      lNameController.text,
                                      emailController.text,
                                      passController.text,
                                      context,
                                    );

                                if (userCred != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const NavBar(),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: context.watch<AuthProviders>().isSignUpLoading
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
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: width * 0.032),
                            child: context
                                    .watch<AuthProviders>()
                                    .isGoogleSignUpLoading
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
                                              .GoogleSignUpFunc(context);
                                      if (account != null) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NavBar(),
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
                                                const NavBar(),
                                          ),
                                        );
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
          ],
        ),
      ),
    );
  }
}
