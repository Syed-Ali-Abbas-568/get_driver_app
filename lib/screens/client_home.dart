import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:get_driver_app/screens/driver_profile.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'login_screen.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  String name = "John";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff152C5E),
        elevation: 8,
        title: const Center(child: Text("Home")),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            "assets/images/profile.png",
            width: width * 0.08,
            height: height * 0.036,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FacebookAuth.instance.logOut();
              FirebaseAuth.instance.signOut().then((value) {
                SnackBarWidget.SnackBars(
                  "Signout successful",
                  "assets/images/successImg.png",
                  context: context,
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
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
            ),
            SizedBox(
              height: height * 0.84,
              child: StreamBuilder<QuerySnapshot>(
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
                          child: ListTile(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                            leading: Image.network(
                              "https://lh3.googleusercontent.com/a-/ACNPEu-MZfXE2mhSgAKC14DoWfcb5AF362qI11y4MP42=s96-c",
                              width: width * 0.194,
                              height: height * 0.093,
                              alignment: Alignment.center,
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
                                        name:
                                            "${data?.get('firstName')} ${data?.get("lastName")}",
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
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
