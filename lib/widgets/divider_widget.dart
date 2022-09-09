import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double width;
  final double height;
  const DividerWidget({Key? key,required this.width,required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1,
          margin: EdgeInsets.only(
              left: width * 0.05,
              bottom: height * 0.035,
              top: height * 0.043,
              right: 1),
          width: width * 0.373,
          color: const Color(0xff8893AC),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 1.5,right: 1.5),
          child: Text(
            "or",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff8893AC),
          ),),
        ),
        Container(
          height: 1,
          margin: EdgeInsets.only(right: width*0.05,bottom: height*0.035,top:height*0.043,left: 1),
          width: width*0.373,
          color: const Color(0xff8893AC),
        ),
      ],
    )    ;
  }
}
