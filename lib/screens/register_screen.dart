// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_driver_app/screens/client_createProfile.dart';
import 'package:get_driver_app/screens/client_home.dart';
import 'package:provider/provider.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/auth_providers.dart';
import 'package:get_driver_app/screens/driver_create_profile.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:get_driver_app/widgets/divider_widget.dart';
import 'package:get_driver_app/widgets/email_password_textfields.dart';
import 'package:get_driver_app/widgets/img_button.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';
import 'login_screen.dart';

enum UserType { driver, client }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _lNameController = TextEditingController();
  final _passController = TextEditingController();
  final _fNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedUserIndex = 0;
  String _selectedUserType = UserType.values[0].name;
  double _height = 0;
  double _width = 0;

  Color _selectButtonColor(int index) {
    if (_selectedUserIndex == index) {
      return const Color(0xff152C5E);
    } else {
      return Colors.white;
    }
  }

  Color _selectButtonTextColor(int index) {
    if (_selectedUserIndex != index) {
      return const Color(0xff152C5E);
    } else {
      return Colors.white;
    }
  }

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
                top: _height * 0.06,
                left: _width * 0.16,
                right: _width * 0.16,
              ),
              child: SizedBox(
                width: _width * 0.66,
                child: Row(
                  children: [
                    Material(
                      color: _selectButtonColor(UserType.client.index),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            _selectedUserType = UserType.values[1].name;
                            _selectedUserIndex = UserType.client.index;
                          });
                        },
                        height: 42.0,
                        child: Text(
                          'Signup as ${UserType.values[1].name}',
                          style: TextStyle(
                            color:
                                _selectButtonTextColor(UserType.client.index),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: _selectButtonColor(UserType.driver.index),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      child: MaterialButton(
                        splashColor: null,
                        onPressed: () {
                          setState(() {
                            _selectedUserType = UserType.values[0].name;
                            _selectedUserIndex = UserType.driver.index;
                          });
                        },
                        minWidth: 112.0,
                        height: 42.0,
                        child: Text(
                          'Signup as ${UserType.values[0].name}',
                          style: TextStyle(
                            color:
                                _selectButtonTextColor(UserType.driver.index),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: _height * 0.03),
                    TextFieldLabel(
                      height: _height,
                      label: "First Name",
                      top: 0,
                      bottom: _height * 0.01,
                      left: 0,
                      right: 0,
                    ),
                    TextFieldWidget(
                      controller: _fNameController,
                      errorText: "Enter a valid first name",
                      hintText: "John",
                      inputType: TextInputType.name,
                    ),
                    TextFieldLabel(
                      height: _height,
                      bottom: _height * 0.01,
                      top: _height * 0.015,
                      left: 0,
                      right: 0,
                      label: "Last Name",
                    ),
                    TextFieldWidget(
                      controller: _lNameController,
                      errorText: "Enter a valid last name",
                      hintText: "Cena",
                      inputType: TextInputType.name,
                    ),
                    EmailPasswordTextField(
                      emailController: _emailController,
                      passController: _passController,
                      height: _height,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: _height * 0.026),
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
                              final userCred = await context
                                  .read<AuthProvider>()
                                  .signUpWithEmailPass(
                                    _fNameController.text,
                                    _lNameController.text,
                                    _emailController.text,
                                    _passController.text,
                                    _selectedUserType,
                                  );

                              if (userCred != null &&
                                  context.read<AuthProvider>().hasError) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        _selectedUserType == "client"
                                            ? const ClientCreateProfile()
                                            : const DriverCreateProfile(),
                                  ),
                                );
                                SnackBarWidget.SnackBars(
                                  "Signup Successful",
                                  "assets/images/successImg.png",
                                  context: context,
                                );
                              } else {
                                SnackBarWidget.SnackBars(
                                  context.read<AuthProvider>().errorMsg,
                                  "assets/images/errorImg.png",
                                  context: context,
                                );
                              }
                            }
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: context.watch<AuthProvider>().isLoading
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign in",
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
                                      context: context);
                                  return;
                                }

                                UserModel? userModel = await context
                                    .read<AuthProvider>()
                                    .googleSignUpFunc(
                                      _selectedUserType,
                                    );

                                if (userModel == null) return;

                                if (userModel.cnic == null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          userModel.userType == "client"
                                              ? const ClientCreateProfile()
                                              : const DriverCreateProfile(),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => userModel
                                                  .userType ==
                                              "client"
                                          ? ClientHome(
                                              name:
                                                  "${userModel.firstName} ${userModel.lastName}")
                                          : const NavBar(),
                                    ),
                                  );
                                  SnackBarWidget.SnackBars(
                                    "Facebook Sign in successful",
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
                                UserModel? userModel = await context
                                    .read<AuthProvider>()
                                    .facebookSignUp(
                                      _selectedUserType,
                                    );
                                if (userModel == null ||
                                    userModel.cnic == null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          userModel?.userType == "client"
                                              ? const ClientCreateProfile()
                                              : const DriverCreateProfile(),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => userModel
                                                  .userType ==
                                              "client"
                                          ? ClientHome(
                                              name:
                                                  "${userModel.firstName} ${userModel.lastName}")
                                          : const NavBar(),
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
