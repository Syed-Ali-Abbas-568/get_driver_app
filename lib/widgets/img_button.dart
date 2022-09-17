import 'package:flutter/material.dart';

class ImgButton extends StatelessWidget {
  final double height;
  final String img;
  final String text;
  final VoidCallback onPressed;
  const ImgButton(
      {Key? key,
      required this.height,
      required this.text,
      required this.img,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(
            top: height * 0.02,
            bottom: height * 0.02,
            left: height * 0.036,
            right: height * 0.036),
        height: height * 0.063,
        width: height * 0.17,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          border: Border.all(
              color: const Color(0xff8893AC),
              width: 1.0,
              style: BorderStyle.solid,
              strokeAlign: StrokeAlign.inside),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/$img.png",
              height: height * 0.1,
            ),
            const SizedBox(
              width: 11,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xff847C7C),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
