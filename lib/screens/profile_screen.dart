import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';
import 'package:get_driver_app/widgets/toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/image_picker.dart';

//const color variables for editable and non editable
Color readOnly = const Color(0xFF152C5E);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _licenceNumController = TextEditingController();
  final TextEditingController _yearsOfExpController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  bool _editable = false;
  String? _imagePath;
  String? _imageUrl;
  String _name = "";

  Future<void> _getUserData() async {
    final data = await context.read<FirestoreProvider>().getUserData();
    if (data == null) return;
    if (!mounted) return;
    setState(() {
      _firstNameController.text = data.firstName ?? '';
      _lastNameController.text = data.lastName ?? '';
      _imageUrl = data.photoUrl;

      _emailController.text = data.email ?? '';
      _licenceNumController.text = data.license.toString();
      _yearsOfExpController.text = data.experience.toString();
      _cnicController.text = data.cnic.toString();
      _dobController.text = data.date ?? " ";
      _name = "${_firstNameController.text} ${_lastNameController.text}";
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    _cnicController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _licenceNumController.dispose();
    _yearsOfExpController.dispose();
    _dobController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _editable
          ? AppBar(
              title: const Text("Edit Mode"),
              centerTitle: true,
              backgroundColor: readOnly,
              automaticallyImplyLeading: false,
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 1000,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    height: 248,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      color: const Color(0xFF152C5E),
                    ),
                  ),
                  Positioned(
                    height: 365.61,
                    width: 366.24,
                    left: -216,
                    top: -118,
                    child: Image.asset(
                      "assets/images/splash_corner_image.png",
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    height: 365.61,
                    width: 366.24,
                    left: -85,
                    top: 527,
                    child: Image.asset(
                      "assets/images/splash_corner_image.png",
                    ),
                  ),
                  Positioned(
                    height: 108.62,
                    width: 253.64,
                    right: -86.64,
                    top: 139,
                    child: Image.asset(
                      "assets/images/car_logo.png",
                    ),
                  ),
                  Positioned(
                    width: 134,
                    height: 134,
                    top: 165,
                    left: 26,
                    child: GestureDetector(
                      onTap: () async {
                        if (_editable) {
                          _imagePath = await getImage();
                          if (_imagePath != null) {
                            setState(() {});
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: (_imagePath != null)
                              ? FileImage(File(_imagePath!))
                              : (_imageUrl != null && _imagePath != "null")
                                  ? NetworkImage(_imageUrl!)
                                  : const AssetImage(
                                          'assets/images/profile.png')
                                      as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_editable,
                    child: Positioned(
                      top: 270,
                      height: 34,
                      width: 118,
                      right: 18,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF152C5E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: () {
                            _editable = true;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/edit.png'),
                              ),
                              Text(
                                "Edit Details",
                                style: GoogleFonts.manrope(
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 327,
                    child: Text(
                      _name,
                      style: GoogleFonts.manrope(
                        fontStyle: FontStyle.normal,
                        color: const Color(0xFF152C5E),
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 367,
                    child: Text(
                      _emailController.text,
                      style: GoogleFonts.manrope(
                        fontStyle: FontStyle.normal,
                        color: const Color(0xFF8893AC),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 409,
                    width: 113,
                    height: 24,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4FAE6),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Color(0xFF7AE582),
                            size: 17,
                          ),
                          Text(
                            "Available for hire",
                            style: GoogleFonts.manrope(
                              fontStyle: FontStyle.normal,
                              color: const Color(0xFF152C5E),
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   right: 16,
                  //   top: 410,
                  //   width: 79,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [
                  //       const Image(
                  //         image: AssetImage("assets/images/location.png"),
                  //       ),
                  //       Text(
                  //         "Lahore, PK",
                  //         style: GoogleFonts.manrope(
                  //           fontStyle: FontStyle.normal,
                  //           color: const Color(0xFF8893AC),
                  //           fontWeight: FontWeight.w800,
                  //           fontSize: 10,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                      top: 470,
                      left: 16,
                      right: 17,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldLabel(
                            height: height,
                            label: "First Name",
                            top: 0,
                            bottom: height * 0.01,
                            left: 0,
                            right: 0,
                          ),
                          TextFieldWidget(
                            controller: _firstNameController,
                            hintText: "Input First Name Here",
                            errorText: "",
                            inputType: TextInputType.name,
                            enabled: false,
                          ),
                          TextFieldLabel(
                            height: height,
                            label: "Last Name",
                            top: height * 0.02,
                            bottom: height * 0.01,
                            left: 0,
                            right: 0,
                          ),
                          TextFieldWidget(
                            controller: _lastNameController,
                            hintText: "Input Last Name Here",
                            errorText: "Invalid Name",
                            inputType: TextInputType.name,
                            enabled: false,
                          ),
                          TextFieldLabel(
                            height: height,
                            label: "License Number",
                            top: height * 0.02,
                            bottom: height * 0.01,
                            left: 0,
                            right: 0,
                          ),
                          TextFieldWidget(
                            controller: _licenceNumController,
                            hintText: "Input License Number here",
                            errorText: "Invalid or Empty License Number",
                            inputType: TextInputType.number,
                            enabled: _editable,
                          ),
                          TextFieldLabel(
                            height: height,
                            label: "Years of experience",
                            top: height * 0.02,
                            bottom: height * 0.01,
                            left: 0,
                            right: 0,
                          ),
                          TextFieldWidget(
                            controller: _yearsOfExpController,
                            hintText: "Input Years of Experience here",
                            errorText: "Invalid or Empty Value",
                            inputType: TextInputType.number,
                            enabled: _editable,
                          ),
                          TextFieldLabel(
                            height: height,
                            label: "Date of birth",
                            top: height * 0.02,
                            bottom: height * 0.01,
                            left: 0,
                            right: 0,
                          ),
                          TextFieldWidget(
                            controller: _dobController,
                            hintText: "Input DOB here",
                            errorText: "",
                            inputType: TextInputType.datetime,
                            enabled: false,
                          ),
                          TextFieldLabel(
                            height: height,
                            label: "CNIC",
                            top: height * 0.02,
                            bottom: height * 0.01,
                            left: 0,
                            right: 0,
                          ),
                          TextFieldWidget(
                            controller: _cnicController,
                            hintText: "Input CNIC here",
                            errorText: "",
                            inputType: TextInputType.datetime,
                            enabled: false,
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Visibility(
              visible: _editable,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF152C5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 33, 50)),
                child: const Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                onPressed: () {
                  _editable = false;

                  Toast.snackBars("Changes Applied Successfully",
                      const Color(0xFF2DD36F), context);

                  // Toast.snackBars("Could Not Apply Changes ",
                  //     const Color(0xFFFFC409), context);

                  // Toast.snackBars(
                  //     "Entry Unsuccessful", const Color(0xFFFF3939), context);

                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
