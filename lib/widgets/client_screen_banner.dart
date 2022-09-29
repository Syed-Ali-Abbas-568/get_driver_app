import 'package:flutter/material.dart';

class ClientScreenBanner extends StatelessWidget {
  const ClientScreenBanner({
    Key? key,
    required this.width,
    required this.height,
    required this.name,
  }) : super(key: key);

  final double width;
  final double height;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: width * 0.06,
            top: height * 0.07,
            right: width * 0.3,
          ),
          width: width,
          height: height * 0.16,
          decoration: const BoxDecoration(
              color: Color(0xff152C5E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                softWrap: false,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                        text: "Welcome, ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                      text: "$name!",
                    )
                  ],
                ),
              ),
              const Text(
                "Who would you like to ride with today?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
