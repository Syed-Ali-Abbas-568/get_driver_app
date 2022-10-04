import 'package:flutter/material.dart';

import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/widgets/text_field_widget.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';

class ProfileScreenTextFields extends StatelessWidget {
  const ProfileScreenTextFields({
    Key? key,
    required this.height,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required bool editable,
    required String pattern,
    required TextEditingController phoneController,
    required bool userType,
    required TextEditingController licenceNumController,
    required TextEditingController yearsOfExpController,
    required TextEditingController dobController,
    required TextEditingController cnicController,
  })  : _firstNameController = firstNameController,
        _lastNameController = lastNameController,
        _editable = editable,
        _pattern = pattern,
        _phoneController = phoneController,
        _userType = userType,
        _licenceNumController = licenceNumController,
        _yearsOfExpController = yearsOfExpController,
        _dobController = dobController,
        _cnicController = cnicController,
        super(key: key);

  final double height;
  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;
  final bool _editable;
  final String _pattern;
  final TextEditingController _phoneController;
  final bool _userType;
  final TextEditingController _licenceNumController;
  final TextEditingController _yearsOfExpController;
  final TextEditingController _dobController;
  final TextEditingController _cnicController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
            hintText: "",
            errorText: "First Name is required",
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
            hintText: "",
            errorText: "Invalid Name",
            inputType: TextInputType.name,
            enabled: false,
          ),
          TextFieldLabel(
            height: height,
            top: height * 0.01,
            right: 0,
            left: 0,
            bottom: height * 0.01,
            label: "Phone Number",
          ),
          TextFormField(
            enabled: _editable,
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
            decoration: Constants.kMessageTextFieldDecoration,
          ),
          Visibility(
            visible: _userType,
            child: Column(
              children: [
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
                  hintText: "",
                  errorText: "Invalid or Empty License Number",
                  inputType: TextInputType.number,
                  enabled: _editable,
                ),
                TextFieldLabel(
                  height: height,
                  label: "",
                  top: height * 0.02,
                  bottom: height * 0.01,
                  left: 0,
                  right: 0,
                ),
                TextFieldWidget(
                  controller: _yearsOfExpController,
                  hintText: "",
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
                  hintText: "",
                  errorText: "",
                  inputType: TextInputType.datetime,
                  enabled: false,
                ),
              ],
            ),
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
            hintText: "",
            errorText: "",
            inputType: TextInputType.datetime,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
