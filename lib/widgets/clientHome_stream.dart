import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_driver_app/widgets/driver_listTile.dart';

class ClientHomeStream extends StatelessWidget {
  const ClientHomeStream({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('userType', isEqualTo: 'driver')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff152C5E),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Nothing to show",
                style: TextStyle(
                  color: Color(0xff152C5E),
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong try again",
                style: TextStyle(
                  color: Color(0xff152C5E),
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.size,
            itemBuilder: (BuildContext context, int index) {
              final data = snapshot.data?.docs[index];
              return Container(
                margin: EdgeInsets.only(
                  top: height * 0.025,
                  left: width * 0.048,
                  right: width * 0.048,
                ),
                width: width * 0.9,
                height: height * 0.126,
                child: DriverListTile(data: data, width: width, height: height),
              );
            },
          );
        });
  }
}
