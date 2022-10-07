// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_driver_app/constants.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/screens/profile_screen.dart';
import 'package:get_driver_app/screens/search_screen.dart';

import 'package:get_driver_app/widgets/clientHome_stream.dart';
import 'package:get_driver_app/widgets/client_screen_banner.dart';
import 'package:get_driver_app/widgets/signout_alert.dart';
import 'package:provider/provider.dart';

class ClientHome extends StatefulWidget {
  ClientHome({super.key, this.name = "John"});
  String name;
  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  String? imageUrl;
  Image img = Image.asset(
    "assets/images/profile.png",
    width: 29,
    height: 29,
  );
  Future<void> getImage() async {
    //async method was created here
    UserModel? userModel =
        await context.read<FirestoreProvider>().getUserData();
    imageUrl = userModel?.photoUrl;
    log("imageURl= $imageUrl");
  }

  void asyncImageMethod() async {
    await getImage();
    setState(() {});
  }

  @override
  void initState() {
    asyncImageMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff152C5E),
        elevation: 8,
        title: const Center(child: Text("Home")),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()));
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageUrl == null
                    ? img.image
                    : CachedNetworkImageProvider(
                        imageUrl!,
                      ),
                fit: BoxFit.contain,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              signOutAlertDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClientScreenBanner(width: width, height: height, name: widget.name),
            Padding(
              padding: EdgeInsets.only(
                  top: 32,
                  left: width * 0.048,
                  right: width * 0.048,
                  bottom: 31.8),
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                elevation: 3,
                child: TextFormField(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  textAlign: TextAlign.center,
                  decoration: Constants.searchFieldDecoration,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.57,
              child: ClientHomeStream(height: height, width: width),
            ),
          ],
        ),
      ),
    );
  }
}
