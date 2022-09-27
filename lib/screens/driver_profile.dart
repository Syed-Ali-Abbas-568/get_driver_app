import 'package:flutter/material.dart';

class DriverProfile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String phone;
  final int license;
  final int experience;
  const DriverProfile({
    required this.imageUrl,
    required this.name,
    required this.phone,
    required this.license,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffEEF3FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff152C5E),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: width,
            height: height * 0.18,
            decoration: const BoxDecoration(
                color: Color(0xffEEF3FF),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Image.network(imageUrl),
          ),
          ListTile(
            tileColor: const Color(0xffEEF3FF),
            leading: const Icon(Icons.phone),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xff152C5E),
              ),
            ),
            subtitle: Text(
              phone,
              style: const TextStyle(
                color: Color(0xff8893AC),
                fontSize: 15,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: ListTile(
              tileColor: const Color(0xffEEF3FF),
              leading: const Icon(Icons.credit_card),
              title: const Text(
                "License Number",
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xff152C5E),
                ),
              ),
              subtitle: Text(
                license.toString(),
                style: const TextStyle(
                  color: Color(0xff8893AC),
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: ListTile(
              tileColor: const Color(0xffEEF3FF),
              leading: const Icon(Icons.data_exploration),
              title: const Text(
                "Experience",
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xff152C5E),
                ),
              ),
              subtitle: Text(
                experience.toString(),
                style: const TextStyle(
                  color: Color(0xff8893AC),
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
