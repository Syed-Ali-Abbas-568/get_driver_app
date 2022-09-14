import 'package:flutter/material.dart';

class TextFieldLabel extends StatelessWidget {
  const TextFieldLabel(
      {Key? key,
      required this.height,
      required this.top,
      required this.right,
      required this.left,
      required this.bottom,
      required this.label})
      : super(key: key);

  final double height;
  final String label;
  final double top;
  final double bottom;
  final double left;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, bottom: bottom, left: left, right: right),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xff8A95AF),
          fontSize: 14,
        ),
      ),
    );
  }
}
