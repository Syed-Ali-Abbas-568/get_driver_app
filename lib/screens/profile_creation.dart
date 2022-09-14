// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/providers/auth_providers.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:get_driver_app/widgets/image_picker.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({Key? key}) : super(key: key);

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
  double height = 0;

  double width = 0;
  final _formKey = GlobalKey<FormState>();

  final cnicController = TextEditingController();
  final expController = TextEditingController();

  final licenseController = TextEditingController();

  final drivingExpController = TextEditingController();

  final phoneController = TextEditingController();

  final dateController = TextEditingController();
  String? imagePath;

  String name = "";
  String email = "";

  DateTime dateTime = DateTime.now();
  String pattern = '^(?:[+0]9)?[0-9]{11}\$';

  void DateOfBirthPicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        dateTime = pickedDate;
        dateController.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  void getUserData() async {
    String? id;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FacebookAuth.instance.getUserData().then((value) {
        id = value['id'].toString();
      });
    } else {
      id = user.uid;
    }
    FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .snapshots()
        .listen((event) {
      setState(() {
        name = "${event.get('firstName')}${event.get('lastName')}";
        email = event.get('email');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.044, right: width * 0.044),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: height * 0.043,
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Profile Creation",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Color(0xff152C5E),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: height * 0.046, left: width * 0.045),
                    child: TextButton(
                      onPressed: () async {
                        log("Img Button pressed");
                        imagePath = await getImage();
                        if (imagePath != null) {
                          setState(() {});
                        }
                      },
                      child: SizedBox(
                        width: 58,
                        height: 58,
                        child: Align(
                          alignment: Alignment.center,
                          child: (imagePath != null)
                              ? Image.file(File(imagePath!))
                              : Image.asset("assets/images/selectImg.png"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: width * 0.045),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xff152C5E),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.045, top: height * 0.01),
                    child: Text(
                      email,
                      style: const TextStyle(
                        color: Color(0xff8D8E8D),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextFieldLabel(
                      height: height,
                      top: height * 0.044,
                      right: 0,
                      left: 0,
                      bottom: height * 0.01,
                      label: "CNIC No"),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "CNIC is required";
                      }
                      if (value.length < 13) {
                        return "Please enter a complete CNIC";
                      }
                      return null;
                    },
                    cursorColor: const Color(0xff152C5E),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: cnicController,
                    decoration: kMessageTextFieldDecoration.copyWith(
                      hintText: "xxxxxxxxxxxxx",
                    ),
                  ),
                  TextFieldLabel(
                      height: height,
                      top: height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: height * 0.01,
                      label: "Phone Number"),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone number required";
                      }
                      if (!RegExp(pattern).hasMatch(value)) {
                        return "Please enter a valid phone number";
                      }
                      return null;
                    },
                    cursorColor: const Color(0xff152C5E),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: kMessageTextFieldDecoration.copyWith(
                      hintText: "+92----------",
                    ),
                  ),
                  TextFieldLabel(
                      height: height,
                      top: height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: height * 0.01,
                      label: "License number"),
                  TextFieldWidget(
                    controller: licenseController,
                    hintText:
                        "Enter your 16 digit license number without dashes",
                    errorText: "16 digits of License number are required",
                    inputType: TextInputType.number,
                    length: 16,
                  ),
                  TextFieldLabel(
                      height: height,
                      top: height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: height * 0.01,
                      label: "Date of birth"),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Date of Birth is required";
                      } else {
                        return null;
                      }
                    },
                    onTap: () {
                      DateOfBirthPicker();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: dateController,
                    keyboardType: TextInputType.none,
                    decoration: kMessageTextFieldDecoration.copyWith(
                        hintText: "MM/DD/YYYY",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range,
                              color: Color(0xff152C5E)),
                          onPressed: () {
                            DateOfBirthPicker();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        )),
                  ),
                  TextFieldLabel(
                      height: height,
                      top: height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: height * 0.01,
                      label: "Experience in years"),
                  TextFieldWidget(
                    controller: expController,
                    hintText: "Enter your Driving experience in years",
                    errorText: "Experience required",
                    inputType: TextInputType.number,
                    length: 1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
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
                              await context
                                  .read<AuthProviders>()
                                  .profileCreation(
                                      dateController.text,
                                      int.parse(expController.text),
                                      int.parse(cnicController.text),
                                      int.parse(licenseController.text),
                                      int.parse(phoneController.text),
                                      context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const NavBar(),
                                ),
                              );
                            }
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child:
                              context.watch<AuthProviders>().isProfileCreation
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
