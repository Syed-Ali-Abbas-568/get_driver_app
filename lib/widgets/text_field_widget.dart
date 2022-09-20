import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.errorText,
    required this.inputType,
    this.enabled = true,
    this.length = 2,
  }) : super(key: key);

  bool enabled;
  final TextEditingController controller;
  final String errorText;
  final TextInputType inputType;
  final String hintText;
  int length;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Field required";
        }
        if (value.length < length) {
          return errorText;
        }
        return null;
      },
      enabled: enabled,
      cursorColor: Colors.purple,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      controller: controller,
      decoration: kMessageTextFieldDecoration.copyWith(
        hintText: hintText,
      ),
    );
  }
}
