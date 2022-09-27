// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/widgets/bottom_navbar.dart';
import 'package:get_driver_app/widgets/image_picker.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class DriverCreateProfile extends StatefulWidget {
  const DriverCreateProfile({Key? key}) : super(key: key);

  @override
  State<DriverCreateProfile> createState() => _DriverCreateProfileState();
}

class _DriverCreateProfileState extends State<DriverCreateProfile> {
  double _height = 0;
  double _width = 0;
  final _formKey = GlobalKey<FormState>();
  final _cnicController = TextEditingController();
  final _expController = TextEditingController();
  final _licenseController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  String? _imagePath;
  String _name = "";
  String _email = "";
  final String _pattern = '^(?:[+0]9)?[0-9]{11}\$';

  void _dateOfBirthPicker() {
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
        _dateController.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: _width * 0.044,
          right: _width * 0.044,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<UserModel?>(
                future: context.read<FirestoreProvider>().getUserData(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<UserModel?> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong try again");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      semanticsLabel: "Loading",
                      color: Color(0xFF152C5E),
                    );
                  }
                  _email = snapshot.data?.email ?? '';
                  _name =
                      "${snapshot.data?.firstName} ${snapshot.data?.lastName}";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: _height * 0.043,
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
                            _imagePath = await getImage();
                            if (_imagePath != null) {
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
                            child: (_imagePath != null)
                                ? CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: FileImage(
                                      File(
                                        _imagePath!,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/edit_image.png',
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        alignment:Alignment.center,
                        padding: EdgeInsets.only(left: _width * 0.045),
                        child: Text(
                          _name,
                          style: const TextStyle(
                            color: Color(0xff152C5E),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment:Alignment.center,
                        margin: EdgeInsets.only(
                          left: _width * 0.045,
                          top: _height * 0.01,
                        ),
                        child: Text(
                          _email,
                          style: const TextStyle(
                            color: Color(0xff8D8E8D),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldLabel(
                      height: _height,
                      top: _height * 0.044,
                      right: 0,
                      left: 0,
                      bottom: _height * 0.01,
                      label: "CNIC No",
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "CNIC is required";
                        }
                        if (value.length < 13) {
                          return "Enter a CNIC of 13 digits ${13 - value.length} digits remaining";
                        }
                        if (value.length > 13) {
                          return "Enter CNIC of 13 digits ${value.length - 13} digits are extra";
                        }
                        return null;
                      },
                      cursorColor: const Color(0xff152C5E),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: _cnicController,
                      decoration: kMessageTextFieldDecoration.copyWith(
                        hintText: "xxxxxxxxxxxxx",
                      ),
                    ),
                    TextFieldLabel(
                      height: _height,
                      top: _height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: _height * 0.01,
                      label: "Phone Number",
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone number required";
                        }
                        if (!RegExp(_pattern).hasMatch(value)) {
                          return "Please enter a valid phone number";
                        }
                        return null;
                      },
                      cursorColor: const Color(0xff152C5E),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: kMessageTextFieldDecoration.copyWith(
                        hintText: "+92----------",
                      ),
                    ),
                    TextFieldLabel(
                      height: _height,
                      top: _height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: _height * 0.01,
                      label: "License Number",
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "License is required";
                        }
                        if (value.length < 16) {
                          return "Enter License number of 16 digits ${16 - value.length} digits remaining";
                        }
                        if (value.length > 16) {
                          return "Enter License number of 16 digits ${value.length - 16} digits are extra";
                        }
                        return null;
                      },
                      cursorColor: const Color(0xff152C5E),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: _licenseController,
                      decoration: kMessageTextFieldDecoration.copyWith(
                        hintText:
                            "Enter your 16 digit license number without dashes",
                      ),
                    ),
                    TextFieldLabel(
                      height: _height,
                      top: _height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: _height * 0.01,
                      label: "Date of birth",
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Date of Birth is required";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _dateOfBirthPicker();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: _dateController,
                      keyboardType: TextInputType.none,
                      decoration: kMessageTextFieldDecoration.copyWith(
                          hintText: "MM/DD/YYYY",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range,
                                color: Color(0xff152C5E)),
                            onPressed: () {
                              _dateOfBirthPicker();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          )),
                    ),
                    TextFieldLabel(
                      height: _height,
                      top: _height * 0.01,
                      right: 0,
                      left: 0,
                      bottom: _height * 0.01,
                      label: "Experience in years",
                    ),
                    TextFieldWidget(
                      controller: _expController,
                      hintText: "Enter your Driving experience in years",
                      errorText: "Experience required",
                      inputType: TextInputType.number,
                      length: 1,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: _height * 0.055),
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
                                    .read<FirestoreProvider>()
                                    .uploadRemainingData(
                                      _imagePath ?? "null",
                                      _dateController.text,
                                      int.parse(_expController.text),
                                      int.parse(_cnicController.text),
                                      int.parse(_licenseController.text),
                                      _phoneController.text,
                                    );

                                final firestoreProvider =
                                    context.read<FirestoreProvider>();
                                if (firestoreProvider.hasFirestoreError) {
                                  SnackBarWidget.SnackBars(
                                    firestoreProvider.firestoreErrorMsg,
                                    "assets/images/errorImg.png",
                                    context: context,
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const NavBar(),
                                    ),
                                  );
                                  SnackBarWidget.SnackBars(
                                    "Data Added successfully",
                                    "assets/images/successImg.png",
                                    context: context,
                                  );
                                  await context
                                      .read<FirestoreProvider>()
                                      .getUserData();
                                }
                              }
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
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
