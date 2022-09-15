import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WrongPasswordException implements Exception {
  final String message;

  WrongPasswordException(this.message);
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException(this.message);
}

class UnkownException implements Exception {
  final String message;

  UnkownException(this.message);
}

class FirebaseAuthService {
  static final _auth = FirebaseAuth.instance;
  final firebaseUser = _auth.currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['Email']);
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordException('You have entered a wrong password');
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundException('User not found');
      } else {
        throw UnkownException('Something went wrong ${e.code} ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>?> facebookLogin(BuildContext context) async {
    try {
      LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        log(result.status.toString());
        final requestData = await FacebookAuth.instance.getUserData();
        SnackBarWidget.SnackBars(
          "Sign in successful",
          "assets/images/successImg.png",
          context,
        );
        return requestData;
      } else {
        SnackBarWidget.SnackBars("Something went wrong try again",
            "assets/images/errorImg.png", context);
      }
    } catch (e) {
      log(e.toString());
      SnackBarWidget.SnackBars("Something went wrong try again",
          "assets/images/errorImg.png", context);
    }
    return null;
  }

  Future<GoogleSignInAccount?> googleSignIn(BuildContext context) async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      SnackBarWidget.SnackBars("Something went wrong try again",
          "assets/images/errorImg.png", context);
      return null;
    }
    _user = googleUser;
    SnackBarWidget.SnackBars(
        "Google login successful", "assets/images/successImg.png", context);
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    return _user;
  }

  Future<UserCredential?> SignUp(String fName, String lName, String email,
      String password, BuildContext context) async {
    try {
      UserCredential? userCredential;
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        userCredential = value;
        postDetailsToFireStore(
            fName, lName, value.user!.uid, email, "null", true, context);
      }).catchError((e) {
        if (e.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          SnackBarWidget.SnackBars(
              "Email already in use", "assets/images/errorImg.png", context);
          return null;
        }
      });
      return userCredential;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> facebookSignUp(BuildContext context) async {
    try {
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final requestData = await FacebookAuth.instance.getUserData();
        var n = requestData['name'].toString().split(" ");
        String fName = n[0];
        String lName = n[1];
        String email = requestData['email'];
        String id = requestData['id'];
        String url = requestData['picture']['data']['url'];
        postDetailsToFireStore(fName, lName, id, email, url, true, context);
        SnackBarWidget.SnackBars(
            "Sign in successful", "assets/images/successImg.png", context);
        return requestData;
      } else {
        SnackBarWidget.SnackBars("Something went wrong try again",
            "assets/images/errorImg.png", context);
      }
    } catch (e) {
      log(e.toString());
      SnackBarWidget.SnackBars("Something went wrong try again",
          "assets/images/errorImg.png", context);
    }
    return null;
  }

  postDetailsToFireStore(
    String fName,
    String lName,
    String id,
    String email,
    String photoUrl,
    bool firstTime,
    BuildContext context,
  ) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();
      userModel.firstName = fName;
      userModel.lastName = lName;
      userModel.email = email;
      userModel.id = id;
      userModel.photoUrl = photoUrl;
      userModel.firstTime = firstTime;

      await firebaseFirestore
          .collection('Users')
          .doc(user?.uid)
          .set(userModel.toJson());

      SnackBarWidget.SnackBars("Account created successfully",
          "assets/images/successImg.png", context);
    } catch (e) {
      SnackBarWidget.SnackBars(
          e.toString(), "assets/images/errorImg.png", context);
    }
  }

  Future<GoogleSignInAccount?> googleSignUp(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        SnackBarWidget.SnackBars("Something went wrong try again",
            "assets/images/errorImg.png", context);
        return null;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final name = _user!.displayName?.split(" ");

      final String? photoUrl = _user!.photoUrl;

      postDetailsToFireStore(
          name![0], name[1], _user!.id, _user!.email, photoUrl!, true, context);
      SnackBarWidget.SnackBars(
          "Sign in Successful", "assets/images/successImg.png", context);
      return _user;
    } catch (e) {
      log(e.toString());
      SnackBarWidget.SnackBars(
          e.toString(), "assets/images/errorImg.png", context);
    }
    return null;
  }

  void postUserInfo(
    String date,
    int experience,
    int CNIC,
    int license,
    int phone,
    BuildContext context,
  ) async {
    try {
      String? id;

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      if (user == null) {
        FacebookAuth.instance.getUserData().then((value) {
          id = value['id'];
          log(id!);
        });
      } else {
        id = user.uid;
      }
      UserModel userModel = UserModel();
      userModel.experience = experience;
      userModel.license = license;
      userModel.CNIC = CNIC;
      userModel.phone = phone;
      userModel.date = date;
      await firebaseFirestore
          .collection('Users')
          .doc(id)
          .set(userModel.toJson());

      SnackBarWidget.SnackBars("Profile creation successful",
          "assets/images/successImg.png", context);
    } catch (e) {
      log(e.toString());
      SnackBarWidget.SnackBars(
          e.toString(), "assets/images/errorImg.png", context);
    }
  }

  // updateUserPFP(String path) async {
  //   Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");
  //   User? user = _auth.currentUser;
  //   await ref.putFile(File(path));
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   ref.getDownloadURL().then((value) async {
  //     await firebaseFirestore.collection('Users').doc(user?.uid).set({
  //       'photoUrl': value,
  //       'firstTime': false,
  //     });
  //   });
  // }

  Future<QuerySnapshot<Map<String, dynamic>>?> switcher() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var result = await FacebookAuth.instance.getUserData();

      String? uid;
      if (user == null && result['id'] != null) {
        uid = result['id'];
      } else if (user != null && result['id'] == null) {
        uid = user.uid;
      } else {
        uid = null;
      }
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('user_info')
          .snapshots()
          .first
          .then((value) {
        return value;
      });
      return null;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
