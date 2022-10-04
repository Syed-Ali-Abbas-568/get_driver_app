// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/widgets/textfield_label.dart';

class EmailPasswordTextField extends StatefulWidget {
  final emailController;
  final passController;
  final double height;

  const EmailPasswordTextField({
    Key? key,
    required this.emailController,
    required this.passController,
    required this.height,
  }) : super(key: key);

  @override
  State<EmailPasswordTextField> createState() => _EmailPasswordTextFieldState();
}

class _EmailPasswordTextFieldState extends State<EmailPasswordTextField> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldLabel(
          height: widget.height,
          top: widget.height * 0.02,
          right: 0,
          left: 0,
          bottom: widget.height * 0.01,
          label: "Email",
        ),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Email is required";
            }
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(value)) {
              return "Enter a valid email";
            }
            return null;
          },
          cursorColor: Colors.purple,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          controller: widget.emailController,
          decoration: Constants.kMessageTextFieldDecoration.copyWith(
            hintText: 'example@gmail.com',
          ),
        ),
        TextFieldLabel(
          height: widget.height,
          top: widget.height * 0.02,
          bottom: widget.height * 0.01,
          left: 0,
          right: 0,
          label: "Password",
        ),
        TextFormField(
          validator: (value) {
            RegExp regex = RegExp(r"^.{8,}$");
            if (value!.isEmpty) {
              return "Password is required";
            }
            if (!regex.hasMatch(value)) {
              return "Password must contain 8 characters minimum";
            }
            return null;
          },
          cursorColor: Colors.purple,
          textInputAction: TextInputAction.done,
          obscureText: _passwordVisible,
          controller: widget.passController,
          decoration: Constants.kMessageTextFieldDecoration.copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
            hintText: 'Password',
          ),
        ),
      ],
    );
  }
}
