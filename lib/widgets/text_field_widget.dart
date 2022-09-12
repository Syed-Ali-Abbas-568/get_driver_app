import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    Key? key,
    required this.fNameController,
    required this.hintText,
    required this.errorText,
    required this.inputType,
    this.enabled = true,
  }) : super(key: key);

  bool enabled;
  final TextEditingController fNameController;
  final String errorText;
  final TextInputType inputType;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Field required";
        }
        if (value.length < 2) {
          return errorText;
        }
        return null;
      },
      enabled: enabled,
      cursorColor: Colors.purple,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      controller: fNameController,
      decoration: kMessageTextFieldDecoration.copyWith(
        hintText: hintText,
      ),
    );
  }
}
