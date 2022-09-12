// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['Email']);
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<UserCredential?> signIn(
      String email, String password, BuildContext context) async {
    UserCredential? userCredentials;
    try {
      userCredentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      SnackBarWidget.SnackBars(
          "Sign in successful", "assets/images/successImg.png", context);
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        SnackBarWidget.SnackBars(
            "Incorrect Password", "assets/images/errorImg.png", context);
      } else if (e.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        SnackBarWidget.SnackBars(
            "Account not found", "assets/images/errorImg.png", context);
      } else {
        SnackBarWidget.SnackBars(
            "Something went wrong", "assets/images/errorImg.png", context);
      }
      log(e.toString());
    }
    return userCredentials;
  }

  Future<Map<String, dynamic>?> facebookLogin(BuildContext context) async {
    try {
      LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final requestData = await FacebookAuth.instance.getUserData();
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
        postDetailsToFireStore(fName, lName, value.user!.uid, email, context);
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

  postDetailsToFireStore(
    String fName,
    String lName,
    String id,
    String email,
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
      await firebaseFirestore
          .collection('Users')
          .doc(user?.uid)
          .set(userModel.toMap());

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
      postDetailsToFireStore(
          name![0], name[1], _user!.id, _user!.email, context);
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
}
