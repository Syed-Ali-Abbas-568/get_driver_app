import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_driver_app/screens/driver_profile.dart';

class DriverListTile extends StatelessWidget {
  const DriverListTile({
    Key? key,
    required this.data,
    required this.width,
    required this.height,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?>? data;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        top: 15,
        left: 10,
        right: 10,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      tileColor: const Color(0xffEEF3FF),
      title: Text(
        "${data?.get('firstName')}${data?.get('lastName')}",
        style: const TextStyle(
          color: Color(0xff152C5E),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${data?.get('email')}",
        style: const TextStyle(
          color: Color(0xff8893AC),
          fontSize: 10,
        ),
      ),
      leading: data?.get('photoUrl') == "null"
          ? Container(
              color: Colors.white,
              child: Image.asset("assets/images/profile.png"))
          : Container(
              color: Colors.white,
              child: Image.network(
                data?.get('photoUrl'),
              ),
            ),
      trailing: Material(
        color: const Color(0xff152C5E),
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
        child: MaterialButton(
          splashColor: null,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DriverProfile(
                  imageUrl: data?.get('photoUrl'),
                  name: "${data?.get('firstName')} ${data?.get("lastName")}",
                  phone: data?.get('phone'),
                  license: data?.get('license'),
                  experience: data?.get('experience'),
                ),
              ),
            );
          },
          minWidth: width * 0.262,
          height: height * 0.039,
          child: const Text(
            'Hire',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
