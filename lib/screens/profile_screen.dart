import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/toast.dart';

import 'package:google_fonts/google_fonts.dart';

import '../widgets/image_picker.dart';

//const color variables for editable and non editable
Color readOnly = const Color(0xFF152C5E);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();

  final TextEditingController liscenceNum = TextEditingController();
  final TextEditingController yearsOfExp = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController cnic = TextEditingController();
  bool editable = false;
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 1180,
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
                        if (editable) {
                          imagePath = await getImage();
                          if (imagePath != null) {
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
                          backgroundImage: (imagePath != null)
                              ? FileImage(File(imagePath!))
                              : const AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
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
                          editable = true;
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
                  Positioned(
                    left: 16,
                    top: 327,
                    child: Text(
                      "John Marcus Doe",
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
                      "AceGraxia@gmail.com",
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
                  Positioned(
                    right: 16,
                    top: 410,
                    width: 79,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Image(
                          image: AssetImage("assets/images/location.png"),
                        ),
                        Text(
                          "Lahore, PK",
                          style: GoogleFonts.manrope(
                            fontStyle: FontStyle.normal,
                            color: const Color(0xFF8893AC),
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 470,
                      left: 16,
                      right: 17,
                      height: 700,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "First Name",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: readOnly,
                            ),
                          ),
                          TextFieldWidget(
                            controller: firstName,
                            hintText: "Input First Name Here",
                            errorText: "",
                            inputType: TextInputType.name,
                            enabled: false,
                          ),
                          Text(
                            "Last Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: readOnly),
                          ),
                          TextFieldWidget(
                            controller: lastName,
                            hintText: "Input Last Name Here",
                            errorText: "",
                            inputType: TextInputType.name,
                            enabled: false,
                          ),
                          Text(
                            "License Number",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: readOnly),
                          ),
                          TextFieldWidget(
                            controller: liscenceNum,
                            hintText: "Input License Number here",
                            errorText: "",
                            inputType: TextInputType.number,
                            enabled: editable,
                          ),
                          Text(
                            "Years of Experience",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: readOnly),
                          ),
                          TextFieldWidget(
                            controller: yearsOfExp,
                            hintText: "Input Years of Experience here",
                            errorText: "",
                            inputType: TextInputType.number,
                            enabled: editable,
                          ),
                          Text(
                            "Date of Birth",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: readOnly),
                          ),
                          TextFieldWidget(
                            controller: dob,
                            hintText: "Input DOB here",
                            errorText: "",
                            inputType: TextInputType.datetime,
                            enabled: false,
                          ),
                          Text(
                            "CNIC",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: readOnly),
                          ),
                          TextFieldWidget(
                            controller: cnic,
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
              visible: editable,
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
                  editable = false;

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
