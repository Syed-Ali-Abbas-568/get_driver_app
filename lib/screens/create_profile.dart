// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:get_driver_app/widgets/image_picker.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
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
            builder: (context, child) {
              return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: primaryColor,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white),
                    ),
                  ),
                  child: child!);
            },
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
    Future.delayed(Duration.zero, () async {
      final data = await context.read<FirestoreProvider>().getUserData();
      if (data == null) return;
      if (!mounted) return;
      email = data.email ?? '';
      name = "${data.firstName} ${data.lastName}";
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
                        "Create Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Color(0xff152C5E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        imagePath = await getImage();
                        if (imagePath != null) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: (imagePath != null)
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: FileImage(File(imagePath!)))
                            : Image.asset(
                                'assets/images/edit_image.png',
                                color: Colors.black,
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
                          onPressed: () {
                            update();
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: context
                                  .watch<FirestoreProvider>()
                                  .isProfileCreation
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

  Future<void> update() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      await context.read<FirestoreProvider>().uploadRemainingData(
          "null",
          dateController.text,
          int.parse(expController.text),
          int.parse(cnicController.text),
          int.parse(licenseController.text),
          phoneController.text);

      final firestoreProvider = context.read<FirestoreProvider>();
      if (firestoreProvider.hasFirestoreError) {
        SnackBarWidget.SnackBars(
            firestoreProvider.FirestoreErrorMsg, "assets/images/errorImg.png",
            context: context);
      } else {
        SnackBarWidget.SnackBars(
          "Data Added successfully",
          "assets/images/successImg.png",
          context: context,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NavBar(),
          ),
        );
      }
    }
  }
}
