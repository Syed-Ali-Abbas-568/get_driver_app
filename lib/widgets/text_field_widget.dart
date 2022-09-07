import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.fNameController,
    required this.hintText,
    required this.errorText,
    required this.inputType,
  }) : super(key: key);

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
