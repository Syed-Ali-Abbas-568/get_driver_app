// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/screens/driver_profile.dart';

class DriverListTile extends StatelessWidget {
  const DriverListTile({
    Key? key,
    required this.data,
    required this.width,
    required this.height,
  }) : super(key: key);

  final UserModel data;
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
        "${data.firstName}${data.lastName}",
        style: const TextStyle(
          color: Color(0xff152C5E),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "${data.email}",
        style: const TextStyle(
          color: Color(0xff8893AC),
          fontSize: 10,
        ),
      ),
      leading: data.photoUrl == null
          ? Container(
              color: Colors.white,
              child: Image.asset("assets/images/profile.png"),
            )
          : Container(
              width: 70,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(data.photoUrl.toString()),
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.noRepeat,
                ),
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
                  imageUrl: data.photoUrl ?? Constants.defaultImage,
                  name: "${data.firstName} ${data.lastName}",
                  phone: data.phoneNO.toString(),
                  license: data.licenseNO!.toInt(),
                  experience: data.experience!.toInt(),
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
